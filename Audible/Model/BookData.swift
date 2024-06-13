import UIKit

struct BookReview {
    let id: String
    let createDate: Date
    let content: String
    
    init(id: String = UUID().uuidString, createDate: Date = Date() , content: String) {
        self.id = id
        self.createDate = createDate
        self.content = content
    }
}

struct BookData {
    let id: String
    let imageName: String
    let title: String
    let subTitle: String
    let authors: [String]
    let rating: String
    var reviews: [BookReview]
    var isInLibraryMyBooks: Bool
    let priceInCredits: Int
    
    init(id: String = UUID().uuidString,
         imageName: String,
         title: String,
         subTitle: String,
         authors: [String],
         rating: String,
         reviews: [BookReview],
         isInLibraryMyBooks: Bool = false,
         priceInCredits: Int) {
        
        self.id = id 
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
