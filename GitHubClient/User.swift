struct User {
    let id: Int
    let name: String
    let iconUrl: String
    let webUrl: String
    
    init(attributes: [String: Any]) {
        self.id = attributes["id"] as! Int
        self.name = attributes["login"] as! String
        self.iconUrl = attributes["avatar_url"] as! String
        self.webUrl = attributes["html_url"] as! String
    }
}
