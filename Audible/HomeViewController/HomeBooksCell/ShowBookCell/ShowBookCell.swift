import UIKit

class ShowBookCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var authorsLable: UILabel!

    func configure(_ book: BookData) {
        coverImageView.image = UIImage(named: book.imageName)
        titleLable.text = book.title
        authorsLable.text = "By " + book.authors.joined(separator: ", ")
    }
}

