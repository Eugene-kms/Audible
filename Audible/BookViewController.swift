import UIKit

struct BookView {
    let image: UIImage
    let title: String
    let subTitle: String
}

//class for all screen of books
class BookViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    
    var bookView: BookView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        iconImageView.image = bookView.image
        titleLbl.text = bookView.title
        subTitleLbl.text = bookView.subTitle
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func playButton(_ sender: Any) {
        print("Play Button")
    }
    
}
