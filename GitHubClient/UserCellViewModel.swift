import UIKit
import Foundation

enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

extension UIImage {
    class func colorImage(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
 
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

final class UserCellViewModel {
    private var user: User
    private var imageDownloader = ImageDownloader()
    private var isLoading = false
    var nickName: String {
        return user.name
    }
    var webUrl: URL {
        return URL(string: user.webUrl)!
    }
    
    init(user: User) {
        self.user = user
    }
    
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        if isLoading {
            return
        } else {
            isLoading.toggle()
        }
        let loadingImage = UIImage.colorImage(color: .gray, size: CGSize(width: 45, height: 45))
        progress(.loading(loadingImage))
        imageDownloader.downloadImage(imageURL: user.iconUrl) { result in
            switch result {
            case .success(let image):
                progress(.finish(image))
                self.isLoading = false
            case .failure(_):
                progress(.error)
                self.isLoading = false
            }
        }
    }
}

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
