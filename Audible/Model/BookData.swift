import UIKit

struct BookData {
    let image: UIImage
    let title: String
    let subTitle: String
    let authors: [String]
    let rating: String
    var reviews: [String]
    let isInLibraryMyBooks: Bool
    let priceInCredits: Int
    
    init(image: UIImage, title: String, subTitle: String, authors: [String], rating: String, reviews: [String], isInLibraryMyBooks: Bool = false, priceInCredits: Int) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.authors = authors
        self.rating = rating
        self.reviews = reviews
        self.isInLibraryMyBooks = isInLibraryMyBooks
        self.priceInCredits = priceInCredits
    }
}
