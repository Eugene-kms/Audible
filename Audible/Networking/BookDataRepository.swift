import UIKit

//curl 'https://audible-9df36-default-rtdb.europe-west1.firebasedatabase.app/audible.json'

/* curl -X POST -d '{
    "image": "startWithWhy",
    "rating": 4.5,
    "reviews": {
        "0": "Very good message, but highly repetitive",
        "1": "es wiederholt sich, aber",
        "2": "amazing book",
        "3": "Listen and learn",
        "4": "Gut, aber hinten raus repititiv",
        "5": "A worthy book."
    },
    "subtitle": "How Great Leaders Inspire Everyone to Take Action",
    "title": "Start with Why"
}' 'https://audible-9df36-default-rtdb.europe-west1.firebasedatabase.app/audible.json' */

//curl -X POST -d '{ "authors" }' 'https://audible-9df36-default-rtdb.europe-west1.firebasedatabase.app/audible.json'

struct FirebasePostResponsDTO: Codable {
    let name: String
}

protocol BookDataRepository {
    func fetchBookData() async throws -> [BookData]
    func addBookToLibraryMyBooks(_ book: BookData) async throws
    func postReview(_ review: String, to book: BookData) async throws
    func deleteBook(_ book: BookData) async throws
}

class BookDataRepositoryLive: BookDataRepository {
    
    typealias BookDataResponse = [String: BookDataDTO]
    
    private lazy var booksUrl = baseUrl.appending(path: "audible.json")
    
    private let baseUrl = URL(string: "https://audible-9df36-default-rtdb.europe-west1.firebasedatabase.app/")!
    
    private lazy var decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    private lazy var encoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return encoder
    }()
    
    func fetchBookData() async throws -> [BookData] {
        let request = URLRequest(url: booksUrl)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try decoder.decode(BookDataResponse.self, from: data)
        
        return toDomain(decoded)
    }
    
    func addBookToLibraryMyBooks(_ book: BookData) async throws {
        
        var request = URLRequest(url: booksUrl)
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(book.toData)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try decoder.decode(FirebasePostResponsDTO.self, from: data)
        
        print("Successfully added \(book.title) to database with id \(decoded.name)")
    }
    
    func postReview(_ review: String, to book: BookData) async throws {
        var request = URLRequest(url: baseUrl.appending(path: "audible/\(book.id)/reviews.json"))
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(BookDataDTO.ReviewDTO(createDate: Date(), content: review))
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try decoder.decode(FirebasePostResponsDTO.self, from: data)
        
        print("Successfully posted review to book \(book.title) with review id \(decoded.name)")
    }
    
    func deleteBook(_ book: BookData) async throws {
        var request = URLRequest(url: baseUrl
            .appending(path: "audible/\(book.id).json"))
        
        request.httpMethod = "DELETE"
        
        let _ = try await URLSession.shared.data(for: request)
        
        print("Successfully deleted book with id \(book.id)")
    }
    
    private func toDomain(_ bookDataResponse: BookDataResponse) -> [BookData] {
        
        var result = [BookData]()
        
        for (id, bookDataDTO) in bookDataResponse {
            result.append(bookDataDTO.toDomain(with: id))
        }
        
        return result
    }
}

extension BookReview {
    var toData: BookDataDTO.ReviewDTO {
        BookDataDTO.ReviewDTO(createDate: createDate,
                              content: content)
    }
}

extension BookDataDTO {
    
    func toDomain(with id: String) -> BookData {
        
        var reviews: [BookReview] = []
        for (id, review) in self.reviews {
            reviews.append(BookReview(id: id, createDate: review.createDate, content: review.content))
        }
        
        return BookData(
            id: id,
            imageName: image,
            title: title,
            subTitle: subtitle,
            authors: authors,
            rating: rating,
            reviews: reviews.sorted(by: { $0.createDate < $1.createDate }),
            isInLibraryMyBooks: true,
            priceInCredits: priceInCredits)
    }
}

extension BookData {
    
    var toData: BookDataDTO {
        
        var reviews: [String: BookDataDTO.ReviewDTO] = [:]
        for review in self.reviews {
            reviews[review.id] = review.toData
        }
        
        return BookDataDTO(
            title: title,
            subtitle: subTitle,
            authors: authors,
            image: imageName,
            rating: rating,
            reviews: reviews,
            priceInCredits: priceInCredits)
    }
}
