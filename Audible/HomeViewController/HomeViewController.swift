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
                image: .howWeLearn,
                title: "How We Learn",
                subTitle: "",
                authors: ["Stanislas Dehaene"],
                rating: "",
                reviews: []),
            BookData(
                image: .thinkingFastAndSlow,
                title: "Thinking, Fast and Slow",
                subTitle: "",
                authors: ["Daniel Kahneman"],
                rating: "",
                reviews: []),
            BookData(
                image: .talkingToStrangers,
                title: "Talking to Strangers",
                subTitle: "",
                authors: ["Malcolm Gladwell"],
                rating: "",
                reviews: [])
            ]))
        
        rows.append(similarRow)
        
        let popularRow = Row.books(BooksShowViewModel(
            title: "Popular titles that you could also enjoy",
            books: [
            BookData(
                image: .unstressable,
                title: "Unstressable",
                subTitle: "",
                authors: ["Mo Gawdat", "Alice Law"],
                rating: "",
                reviews: []),
            BookData(
                image: .liberatedLove,
                title: "Liberated Love",
                subTitle: "",
                authors: ["Mark Groves", "Kylie McBeath"],
                rating: "",
                reviews: []),
            BookData(
                image: .kokoro,
                title: "Kokoro",
                subTitle: "",
                authors: ["Beth Kempton"],
                rating: "",
                reviews: []),
            BookData(
                image: .threeSummers,
                title: "Three Summers",
                subTitle: "",
                authors: ["Amra Sabic-El-Rayess", "Laura L. Sullivan"],
                rating: "",
                reviews: [])
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
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
}
