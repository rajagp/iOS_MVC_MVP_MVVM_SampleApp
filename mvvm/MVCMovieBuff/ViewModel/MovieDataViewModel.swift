//
//  MovieDataViewModel.swift
//  MovieBuff
//
//  Created by Mac Tester on 11/5/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation

// In lieu of KVO , Boxing a data type so listeners can be notified of changes to it .


// swift3:Capturing an inout parameter, including self in a mutating method, becomes an error in an escapable closure literal, unless the capture is made explicit (and thereby immutable):
// Hate this : Forced to have a class :-(
class MovieDataViewModel {
    
    var movies:DynamicType<Movies> = DynamicType<Movies>()
    var movieDetails:DynamicType<MovieData> = DynamicType()
    var error:DynamicType<Error> = DynamicType()
  
    func fetchMovieListFromServerForTitle(_ title:String,type:String?,year:String? ,atPage page:Int = 1) {
   
        if page == 1 {
            movies.value?.removeAll()
        }
        ServerManager.sharedInstance.searchForMatchesWithTitle(title, ofType: type, andYear: year, atPage:page){[unowned self]
            (moviesList, error) in
     
            print ("\(#function) moviesList is \(moviesList)")
            if let error = error {
                print ("Error while fetching data \(error)")
                self.error.value = error
                
            }
            else {
                // When set the listener (if any) will be notified
                if let moviesList = moviesList {
                    let toAdd:Movies = moviesList.filter {
                        if self.movies.value == nil {
                            return true
                        }
                        
                       return  self.movies.value?.contains($0) == false
                        
                    }
                    if let _ = self.movies.value {
                       self.movies.value?.append(contentsOf: toAdd)
                    }
                    else {
                        self.movies.value = toAdd
                    }

                }
            }
        }
    }
    
    
    func fetchMovieDetailsByIMDBID(_ id:String) {
        ServerManager.sharedInstance.detailsWithIMDBID(id) { (details, error) in
            print (details)
            if let error = error {
                print ("Error while fetching data \(error)")
                self.error.value = error

            }
            else {
                if let details = details {
                    self.movieDetails.value =  details
                }
            }
        }
    }
}


