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

class BookDataRepository {
    
    typealias BookDataResponse = [String: BookDataDTO]
    
    private let url = URL(string: "https://audible-9df36-default-rtdb.europe-west1.firebasedatabase.app/audible.json")!
    
    func fetchBookData() async throws -> [BookData] {
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try JSONDecoder().decode(BookDataResponse.self, from: data)
        
        return toDomain(decoded)
    }
    
    func addBookToLibraryMyBooks(_ book: BookData) async throws {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(book.toData)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try JSONDecoder().decode(FirebasePostResponsDTO.self, from: data)
        
        print("Successfully added \(book.title) to database with id \(decoded.name)")
    }
    
    private func toDomain(_ bookDataResponse: BookDataResponse) -> [BookData] {
        
        var result = [BookData]()
        
        for (_, bookDataDTO) in bookDataResponse {
            result.append(bookDataDTO.toDomain)
        }
        
        return result
    }
}

extension BookDataDTO {
    
    var toDomain: BookData {
        BookData(
            imageName: image,
            title: title,
            subTitle: subtitle,
            authors: authors,
            rating: rating,
            reviews: reviews,
            isInLibraryMyBooks: true,
            priceInCredits: priceInCredits)
    }
}

extension BookData {
    
    var toData: BookDataDTO {
        BookDataDTO(
            title: title,
            subtitle: subTitle,
            authors: authors,
            image: imageName,
            rating: rating,
            reviews: reviews,
            priceInCredits: priceInCredits)
    }
}
