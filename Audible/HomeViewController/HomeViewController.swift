import UIKit

struct GreedingCellViewModel {
    let greeting: String
    let subtitle: String
}

struct BooksShowViewModel {
    let title: String
    let books: [BookData]
}

class HomeViewController: UIViewController {
    
    enum Row {
        case greeding(GreedingCellViewModel)
        case books(BooksShowViewModel)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var rows: [Row] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillDataSource()
        
        configureTableView()
    }
    
    private func fillDataSource() {
        
        let greetingRow = Row.greeding(GreedingCellViewModel(
            greeting: "Good afternoon, Ann",
            subtitle: "You have 5 credits"))
        
        rows.append(greetingRow)
        
        let similarRow = Row.books(BooksShowViewModel(
            title: "Similar titles you have listened to",
            books: [
            BookData(
                imageName: "howWeLearn",
                title: "How We Learn",
                subTitle: "How We Learn as it's meant to be heard",
                authors: ["Stanislas Dehaene"],
                rating: "4.6",
                reviews: [],
                priceInCredits: 1),
            BookData(
                imageName: "thinkingFastAndSlow",
                title: "Thinking, Fast and Slow",
                subTitle: "",
                authors: ["Daniel Kahneman"],
                rating: "4.4",
                reviews: [],
                priceInCredits: 1),
            BookData(
                imageName: "talkingToStrangers",
                title: "Talking to Strangers",
                subTitle: "",
                authors: ["Malcolm Gladwell"],
                rating: "4.3",
                reviews: [],
                priceInCredits: 1)
            ]))
        
        rows.append(similarRow)
        
        let popularRow = Row.books(BooksShowViewModel(
            title: "Popular titles that you could also enjoy",
            books: [
            BookData(
                imageName: "unstressable",
                title: "Unstressable",
                subTitle: "",
                authors: ["Mo Gawdat", "Alice Law"],
                rating: "4.5",
                reviews: [],
                priceInCredits: 1),
            BookData(
                imageName: "liberatedLove",
                title: "Liberated Love",
                subTitle: "Love - is love!",
                authors: ["Mark Groves", "Kylie McBeath"],
                rating: "4.6",
                reviews: [],
                priceInCredits: 1),
            BookData(
                imageName: "kokoro",
                title: "Kokoro",
                subTitle: "",
                authors: ["Beth Kempton"],
                rating: "4.6",
                reviews: [],
                priceInCredits: 1),
            BookData(
                imageName: "threeSummers",
                title: "Three Summers",
                subTitle: "",
                authors: ["Amra Sabic-El-Rayess", "Laura L. Sullivan"],
                rating: "4.7",
                reviews: [],
                priceInCredits: 1)
            ]))
        
        rows.append(popularRow)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "HomeGreetingCell", bundle: nil), forCellReuseIdentifier: "HomeGreetingCell")
        tableView.register(UINib(nibName: "HomeBooksCell", bundle: nil), forCellReuseIdentifier: "HomeBooksCell")
    }
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = rows[indexPath.row]
        
        switch row {
        case .greeding(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeGreetingCell") as! HomeGreetingCell
            cell.configure(with: viewModel)
            cell.selectionStyle = .none
            
            return cell
            
        case .books(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBooksCell") as! HomeBooksCell
            cell.configure(with: viewModel)
            cell.selectionStyle = .none
            
            cell.didSelectBook = { [weak self] book in
                self?.presentDetailBook(book)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
}

extension HomeViewController: UITableViewDelegate {
    
    private func presentDetailBook(_ book: BookData) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        
        viewController.modalPresentationStyle = .fullScreen
        
        Task {
            do {
                let repository = BookDataRepository()
                
                let result = try await repository.fetchBookData()
                
                let bookIsInLibrary = result.contains { element in
                    element.title == book.title
                }
                var edittedBook = book
                edittedBook.isInLibraryMyBooks = bookIsInLibrary
                
                Task { @MainActor in
                    viewController.viewModel = BookViewModel(bookData: edittedBook)
                    
                    present(viewController, animated: true)
                    
                    print("Test - \(edittedBook.isInLibraryMyBooks)")
                }
            } catch {
                print(error)
            }
        }
        
        
    }
}
