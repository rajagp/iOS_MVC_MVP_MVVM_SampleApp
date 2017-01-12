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
    var currPage = 1
    let defaultPageSize = 10
    var movieTitle: String = ""
    var type:String?
    var year:String?
    
    public  var moviesPresenter:MoviesPresenter? {
        didSet {
            // Attach self to the presenter
            moviesPresenter?.attachPresentingView(self)
        }
    }

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
        self.currPage = 1
        self.movieTitle = title
        self.type = type
        self.year = year
        self.shows.removeAll()
        
        // Request presenter to fetch data
        self.moviesPresenter?.fetchMoviesWithTitle(title, type: type, year: year, page:currPage)
        
        // Dismiss the presented search VC
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: MovieListPresentingViewProtocol
extension MovieListViewController:MoviesPresentingViewProtocol {
    func updateUIWithMovies(movies:Movies ) {
        let toAdd:Movies = movies.filter {
            self.shows.contains($0) == false
        }
        
        self.shows.append(contentsOf: toAdd)
        if toAdd.count > 0 {
            self.tableView.reloadData()
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
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC:MovieDetailViewController = self.detailViewControllerForIndexPath(indexPath) as! MovieDetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let fetchNextPage = (self.currPage * defaultPageSize) - 1 == indexPath.row
        if fetchNextPage == true {
            self.currPage = self.currPage + 1
            // Request presenter to fetch data
            self.moviesPresenter?.fetchMoviesWithTitle(self.movieTitle, type: self.type, year: self.year, page:self.currPage)
            
        }
        
    }
    
}

// MARK:UIViewControllerPreviewingDelegate
extension MovieListViewController {
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        let detailVC:MovieDetailViewController = self.detailViewControllerForIndexPath(indexPath) as! MovieDetailViewController
        let cellRect = tableView.rectForRow(at: indexPath)
        let sourceRect = previewingContext.sourceView.convert(cellRect, from: tableView)
        previewingContext.sourceRect = sourceRect
        
        return detailVC
        
    }

    @objc(previewingContext:commitViewController:) public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
    
  
}

// MARK: Helpers
extension MovieListViewController {
    fileprivate func detailViewControllerForIndexPath(_ indexPath:IndexPath)->UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let detailVC:MovieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let show = shows[indexPath.row]
        detailVC.moviesDetailsPresenter = MoviesPresenter()
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


