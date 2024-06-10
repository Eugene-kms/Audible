import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var iconOfBookView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with bookData: BookData) {
        iconOfBookView.image = UIImage(named: bookData.imageName)
        titleLbl.text = "\(bookData.title) (\(bookData.reviews.count))"
    }
    
}
