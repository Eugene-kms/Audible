import Foundation

struct BookDataDTO: Codable {
    
    struct ReviewDTO: Codable {
        let createDate: Date
        let content: String
    }
    
    let title: String
    let subtitle: String
    let authors: [String]
    let image: String
    let rating: String
    let reviews: [String: ReviewDTO]
    let priceInCredits: Int
    
    init(title: String, subtitle: String, authors: [String], image: String, rating: String, reviews: [String: ReviewDTO], priceInCredits: Int) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.image = image
        self.rating = rating
        self.reviews = reviews
        self.priceInCredits = priceInCredits
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
        self.authors = try container.decode([String].self, forKey: .authors)
        self.image = try container.decode(String.self, forKey: .image)
        self.rating = try container.decode(String.self, forKey: .rating)
        self.reviews = try container.decodeIfPresent([String: ReviewDTO].self, forKey: .reviews) ?? [:]
        self.priceInCredits = try container.decode(Int.self, forKey: .priceInCredits)
    }
}

