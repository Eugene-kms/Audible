import Foundation

class MyBooksViewModel {
    
    private let repository: BookDataRepository
    
    var bookData: [BookData] = []
    
    var didFetchBooks: (() -> ())?
    
    init(repository: BookDataRepository = BookDataRepository(), didFetchBooks: @escaping (() -> ())) {
        self.repository = repository
        self.didFetchBooks = didFetchBooks
    }
    
    func fetchAudible() {
        Task {
            do {
               
                let fetchedBookData = try await repository.fetchBookData()
                self.bookData = fetchedBookData.sorted(by: { $0.title < $1.title})
                
                await MainActor.run {
                    self.didFetchBooks?()
                }
            } catch {
                print(error)
            }
        }
    }
}
