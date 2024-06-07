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
        configureButton(with: book)
    }
    
    private func configureButton(with book: BookData) {
        
        if !book.isInLibraryMyBooks {
            playButton.setTitle(configurePurchaseButtonTitle(with: book.priceInCredits), for: .normal)
            playButton.setTitleColor(.white, for: .normal)
            playButton.backgroundColor = .mainButton
        } else {
            playButton.setTitle("Play", for: .normal)
            playButton.setTitleColor(.black, for: .normal)
            playButton.backgroundColor = .secondaryButton
        }
        
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    private func configurePurchaseButtonTitle(with credits: Int) -> String {
        if credits <= 1 {
            return "Purchase (\(credits) credit)"
        } else {
            return "Purchase (\(credits) credits)"
        }
    }
}
