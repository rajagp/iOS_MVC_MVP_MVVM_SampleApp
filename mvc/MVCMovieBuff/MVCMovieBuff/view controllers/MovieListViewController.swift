//
//  MovieListViewController.swift
//  MVCMovieBuff
//
//  Created by Priya Rajagopal on 9/30/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import UIKit


class MovieListViewController: UITableViewController ,UIViewControllerPreviewingDelegate {

    enum Resources {
        case placeholder
        
        var path:String {
            switch  self {
            case .placeholder:
                return Bundle.main.path(forResource: "images", ofType: "png")!
            }
        }
    }
    var shows:Movies = Movies()
    var pageOffset:Int = 1
    let defaultPageSize = 10
    var movieTitle: String = ""
    var type:String?
    var year:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.rowHeight = 80
        registerForPreviewing(with: self, sourceView: self.tableView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

}

// MARK IBActions
extension MovieListViewController {
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue) {
        self.dismiss(animated: true) { 
            print("Search view controller was dismissed")
        }
    }
}

//MARK: SearchViewControllerProtocol
extension MovieListViewController:SearchViewControllerProtocol {
    func searchCriteriaSelected(title:String,type:String?,year:String?) {
        self.movieTitle = title
        self.type = type
        self.year = year
        self.pageOffset = 1
        self.shows.removeAll()
        self.fetchMovieListFromServerForTitle()
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: Server Side Interaction
extension MovieListViewController {
    fileprivate func fetchMovieListFromServerForTitle() {
        showDataLoadingProgressHUD()
        ServerManager.sharedInstance.searchForMatchesWithTitle(self.movieTitle, ofType: self.type, andYear: self.year, atPage:pageOffset) { [unowned self](movies, error) in
            self.hideDataLoadingProgressHUD()
            if let error = error {
                if error.details.code != ServerErrorCodes.noMoreMovies.rawValue {
                        self.showErrorAlertWithTitle("Error!", message: error.details.message)
                }

            }
            else {
                if let movies =  movies {
                    
                    let toAdd:Movies = movies.filter {
                        self.shows.contains($0) == false
                    }
                    
                    self.shows.append(contentsOf: toAdd)
                    self.tableView.reloadData()
                }
                
            }
        }
    }
}

// MARK: Navigation
extension MovieListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue" {
            if let segueDestVC = segue.destination as? UINavigationController {
                if let searchVC = segueDestVC.topViewController as? SearchViewController {
                    searchVC.delegate = self
                }
            }
        }
        if segue.identifier == "ModelDetailSegue" {
            if let _ = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! MovieDetailViewController
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else if let _ = sender as? UITableViewCell , segue.identifier == "ModelDetailPreviewSegue" {
            let controller = segue.destination as! MovieDetailViewController
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
        
    }
    
}

// MARK: UITableViewDataSource
extension MovieListViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
        
    }
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MovieInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoTableViewCell
        
        let show = shows[indexPath.row]
        cell.titleLabel.text = show.title
        cell.yearLabel!.text = show.year
     
        if let poster = show.poster {
            do {
                // for some reason, http loads dont happen despite info.plist changes. So force https prefix
                var components = URLComponents(string: poster)
                components?.scheme = "https"
                do {
                    let URL = try components?.asURL()
                    DispatchQueue.global().async(execute: {
                        do {
                            let imageData = try Data(contentsOf:URL!)
                            DispatchQueue.main.async {
                                cell.posterImageView.image = UIImage.init(data: imageData)
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                cell.posterImageView.image = UIImage.init(contentsOfFile: Resources.placeholder.path)
                            }
                            
                        }
                        
                    })
                   
                }
                catch {
                    DispatchQueue.main.async {
                        cell.posterImageView.image = UIImage.init(contentsOfFile: Resources.placeholder.path)
                    }
                    
                }
             }
          
        }
        else {
            DispatchQueue.main.async {
              cell.posterImageView.image = UIImage.init(contentsOfFile: Resources.placeholder.path)
            }
         }
        
        return cell
        
    }

    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}


// MARK: UITableViewDelegate
extension MovieListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = detailViewControllerFor(indexPath:indexPath)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let fetchNextPage = (self.pageOffset * defaultPageSize) - 1 == indexPath.row
        if fetchNextPage == true {
            self.pageOffset = self.pageOffset + 1
            fetchMovieListFromServerForTitle()
        }
        
    }
    
 
}

// MARK:UIViewControllerPreviewingDelegate
extension MovieListViewController {
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        let detailVC = detailViewControllerFor(indexPath:indexPath)
        let cellRect = tableView.rectForRow(at: indexPath)
        let sourceRect = previewingContext.sourceView.convert(cellRect, from: tableView)
        previewingContext.sourceRect = sourceRect
        
        return detailVC
        
    }

    @objc(previewingContext:commitViewController:) public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
    
  
}

// MARK: Helper
extension MovieListViewController {
    fileprivate func detailViewControllerFor(indexPath:IndexPath) -> MovieDetailViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let detailVC:MovieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let show = shows[indexPath.row]
        detailVC.imdbID = show.imdbID
        if let cell:MovieInfoTableViewCell = tableView.cellForRow(at: indexPath) as? MovieInfoTableViewCell {
            detailVC.posterImage = cell.posterImageView.image
        }
       
        
        return detailVC
        
    }
}
extension MovieListViewController {
    override var previewActionItems: [UIPreviewActionItem]  {
        
        let viewDetails = UIPreviewAction(title: "View Details", style: .default) { (action, viewController) in
            
        }

        return [viewDetails]
    }
}


