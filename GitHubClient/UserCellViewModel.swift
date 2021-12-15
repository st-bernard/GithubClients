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
    private var isLoading = false
    var catchImage: UIImage?
    
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
        
        if let catchImage = self.catchImage {
            progress(.finish(catchImage))
            self.isLoading = false
        }
        
        var request = URLRequest(url: URL(string: user.iconUrl)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //エラーがあった場合
            if error != nil {
                progress(.error)
                self.isLoading = false
                return
            }
            
            guard let data = data else {
                progress(.error)
                self.isLoading = false
                return
            }
            guard let imageFromData = UIImage(data: data) else {
                progress(.error)
                self.isLoading = false
                return
            }
            DispatchQueue.main.async {
                progress(.finish(imageFromData))
                self.isLoading = false
            }
            self.catchImage = imageFromData
        }
        task.resume()
    }
}
