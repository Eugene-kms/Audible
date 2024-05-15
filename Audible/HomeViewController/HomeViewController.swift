import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeGreetingCell", bundle: nil), forCellReuseIdentifier: "HomeGreetingCell")
        tableView.rowHeight = 64
        tableView.register(UINib(nibName: "HomeBooksCell", bundle: nil), forCellReuseIdentifier: "HomeBooksCell")
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            UITableViewCell()
        }
    func numberOfSections(in tableView: UITableView) -> Int {
            1
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
}
