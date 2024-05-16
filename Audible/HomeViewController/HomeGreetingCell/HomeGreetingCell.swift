import UIKit

class HomeGreetingCell: UITableViewCell {

    @IBOutlet weak var greetingLable: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    
    func configure(with viewModel: GreedingCellViewModel) {
        greetingLable.text = viewModel.greeting
        subtitleLable.text = viewModel.subtitle
    }
}
