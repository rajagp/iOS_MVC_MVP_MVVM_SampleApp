//
//  MoviesPresenterProtocols.swift
//  MovieBuff
//
//  Created by Mac Tester on 10/30/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//


import Foundation

// Movies Presenters must implement this protocol
protocol MoviesPresenterProtocol:PresenterProtocol {
    func fetchMoviesWithTitle(_ title:String,type:String?,year:String?, page:Int  )
    func fetchDetailsOfMovileWithIMDBId(_ id:String)

}

// Movie List view/view controller must implement this protocol
protocol MoviesPresentingViewProtocol:PresentingViewProtocol {
    func updateUIWithMovies(movies:Movies )
    func updateUIWithMovieDetails(_ details:MovieData? )
}

// Default implementations of  MoviesPresenterProtocol
extension MoviesPresenterProtocol {
    func fetchMoviesWithTitle(_ title:String,type:String?,year:String? ) {
        print("Invoking default implementation of \(#function)")
    }
    func fetchDetailsOfMovileWithIMDBId(_ id:String) {
        print("Invoking default implementation of \(#function)")
    }

}


// Default implementations of MoviesPresentingViewProtocol
extension MoviesPresentingViewProtocol {
    func updateUIWithMovies(movies:Movies ) {
        print("Invoking default implementation of \(#function)")
    }
    func updateUIWithMovieDetails(_ details:MovieData? ) {
        print("Invoking default implementation of \(#function)")
    }

    
}

