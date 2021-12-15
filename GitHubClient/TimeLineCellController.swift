import Foundation
import UIKit

final class TimeLineViewController: UIViewController {
    
    private var viewModel: UserListViewModel!
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: TimeLineCell.id)
        self.view.addSubview(tableView)
        
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = { [weak self] state in
            switch state {
            case .loading:
                self?.tableView.isUserInteractionEnabled = false
                print("loading........")
            case .finish:
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
            case .error(let error):
                self?.tableView.isUserInteractionEnabled = true
                let alert = UIAlertController(
                    title: error.localizedDescription,
                    message: nil,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        viewModel.getUsers()
    }
    
    @objc private func refreshControlValueDidChange(sender: UIRefreshControl) {
        viewModel.getUsers()
    }
}

extension TimeLineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension TimeLineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timeLineCell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.id) as? TimeLineCell {
            let cellViewModel = self.viewModel.cellViewModels[indexPath.row]
            timeLineCell.setNickName(nickName: cellViewModel.nickName)
            cellViewModel.downloadImage() { progress in
                switch progress {
                case .loading(let image):
                    timeLineCell.setIcon(icon: image)
                case .finish(let image):
                    timeLineCell.setIcon(icon: image)
                case .error:
                    break
                }
            }
            return timeLineCell
        }
        fatalError()
    }
}
