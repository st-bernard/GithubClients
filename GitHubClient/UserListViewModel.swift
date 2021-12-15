import Darwin
import Foundation

enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class UserListViewModel {
    var stateDidUpdate: ((ViewModelState) -> Void)?
    private var users = [User]()
    var cellViewModels = [UserCellViewModel]()
    
    func getUsers() {
        stateDidUpdate?(.loading)
        users.removeAll()
        
        let requestUrl = URL(string: "https://api.github.com/users")
        guard let url = requestUrl else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { return }
            guard let data = data else { return }
            guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            guard let jsons = jsonOptional as? [[String: Any]] else { return }
            
            DispatchQueue.main.async {
                jsons.forEach { json in
                    self.users.append(User(attributes: json))
                }
                self.users.forEach { user in
                    let cellViewModel = UserCellViewModel(user: user)
                    self.cellViewModels.append(cellViewModel)
                    self.stateDidUpdate?(.finish)
                }
            }
        }
        task.resume()
    }
    
    func usersCount() -> Int {
        return users.count
    }
}
