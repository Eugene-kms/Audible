import Foundation

class MyBooksViewModel {
    
    private let repository: BookDataRepository
    
    var bookData: [BookData] = []
    
    var didFetchBooks: () -> ()
    
    init(repository: BookDataRepository = BookDataRepository(), didFetchBooks: @escaping (() -> ())) {
        self.repository = repository
        self.didFetchBooks = didFetchBooks
    }
    
    func fetchAudible() {
        Task {
            do {
                let result = try await
                self.repository.fetchBookData()
                self.bookData = result
                
                await MainActor.run {
                    self.didFetchBooks()
                }
            } catch {
                print(error)
            }
        }
    }
}
