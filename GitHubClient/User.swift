struct User {
    let id: Int
    let name: String
    let iconUrl: String
    
    init(attributes: [String: Any]) {
        self.id = attributes["id"] as! Int
        self.name = attributes["login"] as! String
        self.iconUrl = attributes["avatar_url"] as! String
    }
}
