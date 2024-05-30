import UIKit

class BookHeaderCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playButton.layer.cornerRadius = 22
        playButton.layer.masksToBounds = true
        selectionStyle = .none
    }
    
    func configure(with book: BookData) {
        coverImageView.image = book.image
        titleLable.text = book.title
        subtitleLable.text = book.subTitle
    }
}
