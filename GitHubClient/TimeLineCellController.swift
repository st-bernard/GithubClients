import Foundation
import UIKit

final class TimeLineViewController: UITableViewController {
    
    private var model: Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TimeLineCell.self, forCellReuseIdentifier: TimeLineCell.id)
        
        self.model = Model { [weak self] state in
            switch state {
            case .loading:
                self?.tableView.isUserInteractionEnabled = false
            case .finish:
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let timeLineCell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.id) as? TimeLineCell else { fatalError() }
        let cellViewModel = self.model.users[indexPath.row]
        timeLineCell.nameLabel.text = cellViewModel.name
        print("downloadImage----------")
        cellViewModel.downloadImage() { progress in
            switch progress {
            case .loading(let image):
                timeLineCell.icon.image = image
            case .finish(let image):
                timeLineCell.icon.image = image
            }
        }
        return timeLineCell
    }
}
