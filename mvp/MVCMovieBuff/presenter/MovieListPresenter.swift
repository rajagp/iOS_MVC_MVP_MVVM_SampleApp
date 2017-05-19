//
//  MovieListPresenter.swift
//  MovieBuff
//
//  Created by Mac Tester on 10/12/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation

class MovieListPresenter {
    
    // Presenting view associated with this presenter
    fileprivate weak var attachedView:MovieListPresentingViewProtocol?
}


extension MovieListPresenter:MovieListPresenterProtocol {
    func fetchMoviesWithTitle(_ title:String,type:String?,year:String? ) {
        attachedView?.dataStartedLoading()
        ServerManager.sharedInstance.searchForMatchesWithTitle(title, ofType: type, andYear: year) {[weak self]  (movies, error) in
            print (movies)
            self?.attachedView?.dataFinishedLoading()
            if let error = error {
                self?.attachedView?.showErrorAlertWithTitle("Error!", message: error.localizedDescription)
           
            }
            else {
                if let movies = movies {
                    self?.attachedView?.onMoviesFetched(movies: movies)
                }
                else {
                   self?.attachedView?.onMoviesFetched(movies: [])
                }
 
            }
        }
    }
    
    func attachPresentingView(_ view:PresentingViewProtocol) {
        attachedView = view as? MovieListPresentingViewProtocol
    }
    
    func detachPresentingView(_ view:PresentingViewProtocol){
        if attachedView == view as! _OptionalNilComparisonType {
            attachedView = nil
        }
    }
}
