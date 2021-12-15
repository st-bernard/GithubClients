import Darwin
import Foundation

enum ViewModelState {
    case loading
    case finish
}

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class Model {
    var stateDidUpdate: ((ViewModelState) -> Void)?
    var users = [User]()
    
    func getUsers() {
        stateDidUpdate?(.loading)
        
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
                    let cellViewModel = User(json["login"] as! String, json["avatar_url"] as! String)
                    self.users.append(cellViewModel)
                    self.stateDidUpdate?(.finish)
                }
            }
        }
        task.resume()
    }
}
