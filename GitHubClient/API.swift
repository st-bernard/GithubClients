import Darwin
import Foundation

typealias ResultHandler<T> = (Result<T, Error>) -> Void

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
