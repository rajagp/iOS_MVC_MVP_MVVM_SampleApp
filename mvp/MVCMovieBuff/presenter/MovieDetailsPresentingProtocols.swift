//
//  MovieDetailsPresentingProtocols.swift
//  MovieBuff
//
//  Created by Mac Tester on 10/16/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation


// Movie Detaols Presenters must implement this protocol
protocol MovieDetailsPresenterProtocol:PresenterProtocol {
    func fetchDetailsOfMovileWithIMDBId(_ id:String)
}

// Movie Details view/view controller must implement this protocol
protocol MovieDetailsPresentingViewProtocol:PresentingViewProtocol {
    func onMovieDetailsFetched(_ details:MovieData? )
}
