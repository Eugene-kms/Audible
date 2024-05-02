import UIKit

class AudibleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func present(with bookView: BookView) {
        let bookViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        
        bookViewController.bookView = bookView
        
        present(bookViewController, animated: true)
    }
    
    @IBAction func whyWeSleepTapped(_ sender: Any) {
        present(with: BookView(
            image: .whyWeSleep,
            title: "Why We Sleep",
            subTitle: "Unlocking the Power of Sleep and Dreams"))
    }
    
    @IBAction func dopamineNationTapped(_ sender: Any) {
        present(with: BookView(
            image: .dopamineNation,
            title: "Dopamine Nation",
            subTitle: "Finding Balance in the Age of Indulgence"))
    }
    
    @IBAction func startWithWhyTapped(_ sender: Any) {
        present(with: BookView(
            image: .startWithWhy,
            title: "Start with Why",
            subTitle: "How Great Leaders Inspire Everyone to Take Action"))
    }
    
}
