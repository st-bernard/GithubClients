import UIKit
import Foundation

enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
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

final class User {
    var name:String
    var iconUrl:String
    private var isLoading = false
    
    init(_ name:String, _ iconUrl:String) {
        self.name = name
        self.iconUrl = iconUrl
    }
    
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        if isLoading {
            return
        } else {
            isLoading.toggle()
        }
        
        let loadingImage = UIImage.colorImage(color: .gray, size: CGSize(width: 45, height: 45))
        progress(.loading(loadingImage))
        
        var request = URLRequest(url: URL(string: self.iconUrl)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                self.isLoading = false
                return
            }
            guard let data = data else {
                self.isLoading = false
                return
            }
            guard let imageFromData = UIImage(data: data) else {
                self.isLoading = false
                return
            }
            DispatchQueue.main.async {
                progress(.finish(imageFromData))
                self.isLoading = false
            }
        }
        task.resume()
    }
}
