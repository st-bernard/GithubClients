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
    let api = API()
    
    func getUsers() {
        stateDidUpdate?(.loading)
        users.removeAll()
        
        self.api.getUsers(){ result in
            switch result {
            case .success(let users):
                self.users.append(contentsOf: users)
                users.forEach { user in
                    let cellViewModel = UserCellViewModel(user: user)
                    self.cellViewModels.append(cellViewModel)
                    self.stateDidUpdate?(.finish)
                }
            case .failure(let error):
                self.stateDidUpdate?(.error(error))
                print(error)
            }
        }
    }
    
    func usersCount() -> Int {
        return users.count
    }
}

final class API {
    func getUsers(handler: @escaping ResultHandler<[User]>) {
        let requestUrl = URL(string: "https://api.github.com/users")
        guard let url = requestUrl else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { return }
            guard let data = data else { return }
            guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: [])
            else { return }
            guard let jsons = jsonOptional as? [[String: Any]] else { return }
            
            var users = [User]()
            jsons.forEach { json in
                let user = User(attributes: json)
                users.append(user)
            }
            DispatchQueue.main.async {
                handler(.success(users))
            }
        }
        task.resume()
    }
}
