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
