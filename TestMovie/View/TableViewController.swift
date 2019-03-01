//
//  TableViewController.swift
//  TestMoview
//
//  Created by Xiaolu on 2/25/19.
//

import UIKit

class TableViewController: UITableViewController {
    let noDataLabel : UILabel = {
        let label = UILabel()
        label.text = "No movie available"
        label.textColor  = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let dataManager = DataManager.shared
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "movieCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200;
        tableView.backgroundView  = noDataLabel
        tableView.tableFooterView = UIView()
        tableView.backgroundView?.isHidden = true
        
        dataManager.loadInitData()
        dataManager.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchBar.text = dataManager.searchString
        self.navigationItem.hidesSearchBarWhenScrolling = false
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
        let data = dataManager.getMovieModel(at: indexPath.row)
        if let tableCell = cell as? TableViewCell{
            tableCell.titleLabel.text = data.movieTitle
            tableCell.detailLabel.text = data.introduction
            if let imagepath = data.imageURL{
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
    
    //MARK : - Table view delegate
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        dataManager.cancelTask(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = MovieViewController(dataManager.getMovieModel(at: indexPath.row), dataManager)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK : - Incremental loading
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
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let pretext = searchBar.text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if searchBar.text == pretext{
                self.dataManager.searchString = pretext
                
            }
        }
    }
    func scrollToTop() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - DataManager delegate
extension TableViewController: DataMangerDelegate{
    func dataDidChange(_ isLoadMore : Bool) {
        tableView.backgroundView?.isHidden = dataManager.movieList.count > 0
        self.tableView.reloadData()
        if !isLoadMore && dataManager.movieList.count > 0 { self.scrollToTop()}
    }
}
