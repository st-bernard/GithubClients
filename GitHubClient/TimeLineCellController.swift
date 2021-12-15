import Foundation
import UIKit

final class TimeLineViewController: UITableViewController {
    
    private var viewModel: Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TimeLineCell.self, forCellReuseIdentifier: TimeLineCell.id)
        
        viewModel = Model()
        viewModel.stateDidUpdate = { [weak self] state in
            switch state {
            case .loading:
                self?.tableView.isUserInteractionEnabled = false
            case .finish:
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
            }
        }
        viewModel.getUsers()
    }
}

extension TimeLineViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension TimeLineViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let timeLineCell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.id) as? TimeLineCell else { fatalError() }
        let cellViewModel = self.viewModel.users[indexPath.row]
        timeLineCell.setNickName(nickName: cellViewModel.name)
        cellViewModel.downloadImage() { progress in
            switch progress {
            case .loading(let image):
                timeLineCell.setIcon(icon: image)
            case .finish(let image):
                timeLineCell.setIcon(icon: image)
            }
        }
        return timeLineCell
    }
}
