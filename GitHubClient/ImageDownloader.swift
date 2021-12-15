import UIKit
final class ImageDownloader {
    var catchImage: UIImage?
    
    func downloadImage(imageURL: String, handler: @escaping ResultHandler<UIImage>) {
        if let catchImage = catchImage {
            handler(.success(catchImage))
        }
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    handler(.failure(APIError.unknown))
                }
                return
            }
            guard let imageFromData = UIImage(data: data) else {
                DispatchQueue.main.async {
                    handler(.failure(APIError.unknown))
                }
                return
            }
            DispatchQueue.main.async {
                handler(.success(imageFromData))
            }
            self.catchImage = imageFromData
        }
        task.resume()
    }
}
