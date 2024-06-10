import UIKit

class MyBooksViewController: UIViewController {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel = MyBooksViewModel(
        didFetchBooks:
            { [weak self] in
                self?.tableView.reloadData()
                
                print("Did fetch Books!!!")
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
        
        bookViewController.viewModel = BookViewModel(bookData: bookData)
        
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
