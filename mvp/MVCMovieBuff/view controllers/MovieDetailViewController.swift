//
//  MovieDetailViewController.swift
//  MovieBuff
//
//  Created by Priya Rajagopal on 10/7/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation
import UIKit
class MovieDetailViewController: UITableViewController
{
    
    var imdbID:String? {
        didSet {
            if let imdbID = imdbID {
                fetchMovieDetailsByIMDBID(imdbID)
            }
            else {
                print("Unable to fetch movie details")
            }
        }
    }
    
    public  var moviesDetailsPresenter:MoviesPresenterProtocol? {
        didSet {
            // Attach self to the presenter
            moviesDetailsPresenter?.attachPresentingView(self)
        }
    }

    var posterImage:UIImage?
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releasedDateLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var awardsLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    fileprivate var loading:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        if let posterImage = posterImage {
            self.posterImageView.image = posterImage
        }
        else {
            print("Unable to fetch movie details")
        }
        
        if let imdbID = imdbID {
            fetchMovieDetailsByIMDBID(imdbID)
        }

    }
  
    fileprivate func fetchMovieDetailsByIMDBID(_ id:String) {
        guard loading == false else {return }
        loading = true
        self.moviesDetailsPresenter?.fetchDetailsOfMovileWithIMDBId(id)
    }
    
}


// MARK: Presenter communication
extension MovieDetailViewController:MoviesPresentingViewProtocol {

    func updateUIWithMovieDetails(_ details: MovieData?) {
        if let details = details {
            self.updateUIWithDetails(details)
        }
        
    }

}



// MARK: UI Update

extension MovieDetailViewController {
    fileprivate func updateUIWithDetails(_ details:MovieData) {
        if let languageLabel = languageLabel,let imdbRating = imdbRating,let ratingLabel = ratingLabel,let titleLabel = titleLabel, let releasedDateLabel = releasedDateLabel,let runTimeLabel = runTimeLabel,let directorLabel = directorLabel,let writerLabel = writerLabel,let actorsLabel = actorsLabel,let awardsLabel = awardsLabel,let plotLabel = plotLabel {
        
            languageLabel.text = details.language ?? "Unavailable"
            imdbRating.text = details.imdbRating ?? "N/A"
            ratingLabel.text = details.rating ?? "N/A"
            titleLabel.text = details.title ?? "N/A"
            releasedDateLabel.text = details.released ?? "N/A"
            runTimeLabel.text = details.runtime ?? "N/A"
            directorLabel.text = details.director ?? "N/A"
            writerLabel.text = details.writer ?? "N/A"
            actorsLabel.text = details.actors ?? "N/A"
            awardsLabel.text = details.awards ?? "N/A"
            plotLabel.text = details.plot ?? "N/A"
            
            self.view.layoutIfNeeded()
        }
    }
}

extension MovieDetailViewController {
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
