import UIKit

class MyBooksViewController: UIViewController {
    
    var listOfBooks: [BookData] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfBooks = myBooksLists()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let cell = "MyBookCell"
        tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        tableView.rowHeight = 44
    }
    
    func present(with bookData: BookData) {
        let bookViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        
        bookViewController.modalPresentationStyle = .fullScreen
        
        bookViewController.bookData = bookData
        
        present(bookViewController, animated: true)
    }
    
    private func myBooksLists() -> [BookData] {
        var lists = [BookData]()
        
        lists.append(BookData(
            image: .whyWeSleep,
            title: "Why We Sleep",
            subTitle: "Unlocking the Power of Sleep and Dreams",
            reviews: reviewsWhyWeSleep()))
        
        lists.append(BookData(
            image: .dopamineNation,
            title: "Dopamine Nation",
            subTitle: "Finding Balance in the Age of Indulgence",
            reviews: reviewsDopamineNation()))
        
        lists.append(BookData(
            image: .startWithWhy,
            title: "Start with Why",
            subTitle: "How Great Leaders Inspire Everyone to Take Action",
            reviews: reviewsStartWithWhy()))
        
        return lists
    }
    
    private func reviewsWhyWeSleep() -> [String] {
        var reviews = [String]()
        
        reviews.append("Amazingly informative, unfitting reader")
        reviews.append("In-depth sleep analysis that fails to grasp")
        reviews.append("A must read if you want to live longer")
        reviews.append("That Narrator!!!")
        reviews.append("An eye-opener")
        reviews.append("We don't sleep enough. Here's how.")
        reviews.append("Un libro genial")
        
        return reviews
    }
    
    private func reviewsDopamineNation() -> [String] {
        var reviews = [String]()
        
        reviews.append("Brilliant core message!")
        reviews.append("super")
        reviews.append("Nice Explanation about Addiction")
        reviews.append("Pleasure and pain; honesty and balance")
        reviews.append("Great Book")
        reviews.append("A very good read with great story telling")
        reviews.append("Verständlich, eindringlich und nachhaltig")
        
        return reviews
    }
    
    private func reviewsStartWithWhy() -> [String] {
        var reviews = [String]()
        
        reviews.append("Very good message, but highly repetitive")
        reviews.append("es wiederholt sich, aber")
        reviews.append("amazing book")
        reviews.append("Listen and learn")
        reviews.append("Gut, aber hinten raus repititiv")
        reviews.append("A worthy book.")
        
        return reviews
    }
}

extension MyBooksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookCell") as? MyBookCell else { return UITableViewCell() }
        
        let bookData = listOfBooks[indexPath.row]
        
        cell.configure(with: bookData)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension MyBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookData = listOfBooks[indexPath.row]
        present(with: bookData)
    }
}
