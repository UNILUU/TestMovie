//
//  TableViewController.swift
//  TestMoview
//
//  Created by  on 2/25/19.
//

import UIKit

class TableViewController: UITableViewController {
    let dataManager = DataManager.shared
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "movieCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200;
        
        dataManager.loadInitData()
        dataManager.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchBar.tintColor = UIColor.white
        self.navigationItem.searchController = searchController
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.movieList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        assert(dequeCell is TableViewCell, "cell not valid")
        let cell = dequeCell as! TableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let data = dataManager.movieList[indexPath.row]
        if let tableCell = cell as? TableViewCell{
            tableCell.titleLabel.text = data.title
            tableCell.detailLabel.text = data.overview
            if let imagepath = data.poster_path{
                dataManager.getImage(imageString: imagepath) { (result) in
                    if case .success(let image) = result {
                        if let tableCell = tableView.cellForRow(at: indexPath) as? TableViewCell{
                            tableCell.movieImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
//        let label = UILabel()
//        label.text = "no more movie"
//        label.textColor = UIColor.gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        footerView.addSubview(label)
//        NSLayoutConstraint .activate([
//            label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
//            ])
//        return footerView
//    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let path = dataManager.movieList[indexPath.row].poster_path {
            dataManager.cancelTask(imageString: path)
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offseY = scrollView.contentOffset.y
        let contentH = scrollView.contentSize.height
        if offseY > contentH - scrollView.frame.height{
            dataManager.loadMoreMovie()
        }
    }
}



// MARK: - UISearchBarDelegate
extension TableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        dataManager.searchString = searchBar.text
        return true
    }
}

// MARK: - DataManager delegate
extension TableViewController: DataMangerDelegate{
    func dataDidChange() {
        self.tableView.reloadData()
    }
}