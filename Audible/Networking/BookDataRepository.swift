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

struct BookDataDTO: Codable {
    let title: String
    let subtitle: String
    let image: String
    let rating: String
    let reviews: [String]
    let priceInCredits: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
        self.image = try container.decode(String.self, forKey: .image)
        self.rating = try container.decode(String.self, forKey: .rating)
        self.reviews = try container.decodeIfPresent([String].self, forKey: .reviews) ?? []
        self.priceInCredits = try container.decode(Int.self, forKey: .priceInCredits)
    }
}

class BookDataRepository {
    
    typealias BookDataResponse = [String: BookDataDTO]
    
    func fetchBookData() async throws -> [BookData] {
        
        let url = URL(string: "https://audible-9df36-default-rtdb.europe-west1.firebasedatabase.app/audible.json")!
        
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try JSONDecoder().decode(BookDataResponse.self, from: data)
        
        return toDomain(decoded)
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
            image: UIImage(named: image) ?? UIImage(),
            title: title,
            subTitle: subtitle,
            authors: [],
            rating: rating,
            reviews: reviews,
            isInLibraryMyBooks: true,
            priceInCredits: priceInCredits)
    }
}
