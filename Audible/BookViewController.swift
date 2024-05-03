import UIKit


struct BookData {
    let image: UIImage
    let title: String
    let subTitle: String
    let reviews: [String]
}

//class for all screen of book and reviews
class BookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var bookData: BookData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = 22
        playButton.layer.masksToBounds = true
        
        configure()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        let cell = "MyBookReviewCell"
        tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
    }
    
    func configure() {
        iconImageView.image = bookData.image
        titleLbl.text = bookData.title
        subTitleLbl.text = bookData.subTitle
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension BookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookData.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookReviewCell") as? MyBookReviewCell else { return UITableViewCell() }
        
        let review = bookData.reviews[indexPath.row]
        
        cell.configure(with: review)
        
        return cell
    }
}
