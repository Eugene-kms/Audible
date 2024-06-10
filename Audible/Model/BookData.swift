import UIKit

struct BookData {
    let imageName: String
    let title: String
    let subTitle: String
    let authors: [String]
    let rating: String
    var reviews: [String]
    var isInLibraryMyBooks: Bool
    let priceInCredits: Int
    
    init(imageName: String, 
         title: String,
         subTitle: String,
         authors: [String],
         rating: String,
         reviews: [String],
         isInLibraryMyBooks: Bool = false,
         priceInCredits: Int) {
        
        self.imageName = imageName
        self.title = title
        self.subTitle = subTitle
        self.authors = authors
        self.rating = rating
        self.reviews = reviews
        self.isInLibraryMyBooks = isInLibraryMyBooks
        self.priceInCredits = priceInCredits
    }
}
