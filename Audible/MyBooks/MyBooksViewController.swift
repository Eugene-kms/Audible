import UIKit

class MyBooksViewModel {
    
    private let repository: BookDataRepository
    
    var bookData: [BookData] = []
    
    var didFetchBooks: () -> ()
    
    init(repository: BookDataRepository = BookDataRepository(), didFetchBooks: @escaping (() -> ())) {
        self.repository = repository
        self.didFetchBooks = didFetchBooks
    }
    
    func fetchAudible() {
        Task {
            do {
                let result = try await
                self.repository.fetchBookData()
                self.bookData = result
                
                await MainActor.run {
                    self.didFetchBooks()
                }
            } catch {
                print(error)
            }
        }
    }
}

class MyBooksViewController: UIViewController {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel = MyBooksViewModel(
        didFetchBooks:
            { [weak self] in
                self?.tableView.reloadData()
            })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        viewModel.fetchAudible()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let cell = "BookCell"
        tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        tableView.rowHeight = 44
    }
    
    func present(with bookData: BookData) {
        let bookViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        
        bookViewController.modalPresentationStyle = .fullScreen
        
        bookViewController.bookData = bookData
        
        present(bookViewController, animated: true)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        
        present(viewController, animated: true)
    }
    
}

extension MyBooksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.bookData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as? BookCell else { return UITableViewCell() }
        
        let bookData = viewModel.bookData[indexPath.row]
        
        cell.configure(with: bookData)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension MyBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bookData = viewModel.bookData[indexPath.row]
        present(with: bookData)
    }
}
