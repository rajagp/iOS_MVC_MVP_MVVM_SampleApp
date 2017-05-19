//
//  MovieDetailsPresenter.swift
//  MovieBuff
//
//  Created by Mac Tester on 10/16/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation

class MovieDetailPresenter {
    
    // Presenting view associated with this presenter
    fileprivate weak var attachedView:MovieDetailsPresentingViewProtocol?
}


extension MovieDetailPresenter:MovieDetailsPresenterProtocol {
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
                    self?.attachedView?.onMovieDetailsFetched(movie)
                }
                else {
                    self?.attachedView?.onMovieDetailsFetched(nil)
                }
                
            }
        })
    }
    
    
    func attachPresentingView(_ view:PresentingViewProtocol) {
        attachedView = view as? MovieDetailsPresentingViewProtocol
    }
    
    func detachPresentingView(_ view:PresentingViewProtocol){
        if attachedView == view as! _OptionalNilComparisonType {
            attachedView = nil
        }
    }
}
