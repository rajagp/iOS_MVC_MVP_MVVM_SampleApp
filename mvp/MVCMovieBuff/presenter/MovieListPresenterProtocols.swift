//
//  MovieListPresenterProtocols.swift
//  MovieBuff
//
//  Created by Mac Tester on 10/12/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation

// Movie List Presenters must implement this protocol
protocol MovieListPresenterProtocol:PresenterProtocol {
    func fetchMoviesWithTitle(_ title:String,type:String?,year:String? )
}

// Movie List view/view controller must implement this protocol
protocol MovieListPresentingViewProtocol:PresentingViewProtocol {
    func onMoviesFetched(movies:Movies )
}
