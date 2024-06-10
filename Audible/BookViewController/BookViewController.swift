import UIKit

enum BookViewSection: Int, CaseIterable {
    case header = 0
    case reviews
}

class BookViewModel {
    
    var bookData: BookData
    
    private let repository: BookDataRepository
    
    init(bookData: BookData, repository: BookDataRepository = BookDataRepository()) {
        self.bookData = bookData
        self.repository = repository
    }
    
    func purchaseBook() {
        guard !bookData.isInLibraryMyBooks else { return }
        
        bookData.isInLibraryMyBooks = true
        
        Task {
            do {
                try await repository.addBookToLibraryMyBooks(bookData)
            } catch {
                print(error)
            }
        }
    }

}

//class for all screen of books and reviews
class BookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postReviewView: UIView!
    @IBOutlet weak var postReviewSafeView: UIView!
    @IBOutlet weak var postReviewButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var postReviewSafeBottomConstraint: NSLayoutConstraint!
        
    var viewModel: BookViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureKeyboard()
        configurePostReviewView()
        configureTextField()
        
        setPostReviewButton(enabled: false)
        
        configurePostReviewField(with: viewModel.bookData)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setPostReviewButton(enabled isEnabled: Bool) {
        postButton.isUserInteractionEnabled = isEnabled
        postButton.tintColor = isEnabled ? .tintColor : UIColor(hex: "#737373")?.withAlphaComponent(0.5)
    }
    
    private func configureTextField() {
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    
    @objc private func didChangeText() {
        setPostReviewButton(enabled: isNewItemValid)
    }
    
    private var isNewItemValid: Bool {
        guard let text = textField.text else { return false }
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func configurePostReviewView() {
        
        postReviewView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        postReviewView.layer.shadowOffset = .zero
        postReviewView.layer.shadowRadius = 18.5
        postReviewView.layer.shadowPath = UIBezierPath(rect: postReviewView.bounds).cgPath
        postReviewView.layer.shadowOpacity = 1
    }
    
    private func configurePostReviewField(with book: BookData) {
        postReviewView.isHidden = book.isInLibraryMyBooks
    }
    
    func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let isKeyboardPresent = endFrame.origin.y < UIScreen.main.bounds.size.height
        
        //If keyboard will hide
        if !isKeyboardPresent {
            postReviewSafeBottomConstraint.constant = 0
        } else { //if keyboard will show
            let bottomHeight = 8 + endFrame.height - view.safeAreaInsets.bottom
            postReviewSafeBottomConstraint.constant = -bottomHeight
        }
        
        UIView.animate(withDuration: duration) {
            self.postButton.alpha = isKeyboardPresent ? 1 : 0
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: duration) {
            self.postButton.alpha = isKeyboardPresent ? 1 : 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.bookData.reviews.count - 1, section: BookViewSection.reviews.rawValue), at: .bottom, animated: true)
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cell = "BookReviewCell"
        tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        tableView.register(UINib(nibName: "BookHeaderCell", bundle: nil), forCellReuseIdentifier: "BookHeaderCell")
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard isNewItemValid, let text = textField.text else { return }
        
        viewModel.bookData.reviews.append(text)
        
        let indexPath = IndexPath(row: viewModel.bookData.reviews.count - 1, section: BookViewSection.reviews.rawValue)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        textField.text = ""
        setPostReviewButton(enabled: false)
    }
}

extension BookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        BookViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = BookViewSection(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 1
        case .reviews:
            return viewModel.bookData.reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = BookViewSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookHeaderCell", for: indexPath) as! BookHeaderCell
            
            cell.configure(with: viewModel.bookData)
            cell.didTapPurchase = { [weak self] in
                self?.didTapPurchaseButton()
            }
            
            return cell
            
        case .reviews:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookReviewCell") as? BookReviewCell else { return UITableViewCell() }
            
            let review = viewModel.bookData.reviews[indexPath.row]
            
            cell.configure(with: review)
            
            return cell
        }
    }
    
    private func didTapPurchaseButton() {
        viewModel.purchaseBook()
        configurePostReviewField(with: viewModel.bookData)
        tableView.reloadData()
    }
}

extension BookViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = BookViewSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .header:
            return 412
        case .reviews:
            return 44
        }
    }
}

extension BookViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
