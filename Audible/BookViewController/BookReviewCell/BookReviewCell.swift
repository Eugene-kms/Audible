import UIKit

class BookReviewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with review: String) {
        titleLbl.text = review
    }
}
