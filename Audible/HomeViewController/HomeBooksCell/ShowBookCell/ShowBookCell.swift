import UIKit

class ShowBookCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var authorsLable: UILabel!

    func configure(_ book: BookData) {
        coverImageView.image = book.image
        titleLable.text = book.title
        authorsLable.text = "By " + book.authors.joined(separator: ", ")
    }
}

