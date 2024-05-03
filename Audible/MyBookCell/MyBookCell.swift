import UIKit

class MyBookCell: UITableViewCell {

    @IBOutlet weak var iconOfBookView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with bookData: BookData) {
        iconOfBookView.image = bookData.image
        titleLbl.text = "\(bookData.title) (\(bookData.reviews.count))"
    }
    
}
