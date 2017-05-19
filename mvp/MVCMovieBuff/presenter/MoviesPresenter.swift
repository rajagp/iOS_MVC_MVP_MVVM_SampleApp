//
//  MoviesPresenter.swift
//  MovieBuff
//
//  Created by Mac Tester on 10/30/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation
class MoviesPresenter {
    
    // Presenting view associated with this presenter
    fileprivate weak var attachedView:MoviesPresentingViewProtocol?
    
}


extension MoviesPresenter:MoviesPresenterProtocol {
    func fetchMoviesWithTitle(_ title:String,type:String?,year:String?, page:Int ) {
        
        attachedView?.dataStartedLoading()
        ServerManager.sharedInstance.searchForMatchesWithTitle(title, ofType: type, andYear: year ,atPage:page) {[weak self]  (movies, error) in
            print (movies)
            self?.attachedView?.dataFinishedLoading()
            if let error = error {
                self?.attachedView?.showErrorAlertWithTitle("Error!", message: error.localizedDescription)
                
            }
            else {
                if let movies = movies {
                    // You can include any transformation logic to the data here so it is suitable for display
                    self?.attachedView?.updateUIWithMovies(movies: movies)
                }
                else {
                    self?.attachedView?.updateUIWithMovies(movies: [])
                }
                
            }
        }
    }
    
    func fetchDetailsOfMovileWithIMDBId(_ id:String) {
        attachedView?.dataStartedLoading()
        ServerManager.sharedInstance.detailsWithIMDBID(id, handler: { [weak self](movie, error) in
            self?.attachedView?.dataFinishedLoading()
            print (movie)
            if let error = error {
                self?.attachedView?.showErrorAlertWithTitle("Error!", message: error.localizedDescription)
                
            }
            else {
                if let movie = movie {
                    // You can include any transformation logic to the data here so it is suitable for display
                    self?.attachedView?.updateUIWithMovieDetails(movie)
                }
                else {
                    self?.attachedView?.updateUIWithMovieDetails(nil)
                }
                
            }
            })
    }
    
    func attachPresentingView(_ view:PresentingViewProtocol) {
        attachedView = view as? MoviesPresentingViewProtocol
    }
    
    func detachPresentingView(_ view:PresentingViewProtocol){
        if attachedView == view as! _OptionalNilComparisonType {
            attachedView = nil
        }
    }
}
    
