//
//  MovieData.swift
//  MovieBuff
//
//  Created by Priya Rajagopal on 10/2/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 
 "Poster":
 "http://ia.media-imdb.com/images/M/MV5BMTY5OTU0OTc2NV5BMl5BanBnXkFtZTcwMzU4MDcyMQ@@._V1_SX300.jpg",
 "Title":
 "The Incredibles",
 "Type":
 "movie",
 "Type":
 "2004",
 "imdbID":
 "tt0317705"
 */
struct MoviesList {
    private var contents: [MovieData]
    
    init() {
        self.contents = [MovieData]()
    }
    
    var count: Int { return contents.count }
    
    var isEmpty: Bool { return contents.isEmpty }
    
    var elements: [MovieData] { return contents }
    
    func contains(movie: MovieData) -> Bool {
        return contents.contains(movie)
    }
    
  
    mutating func add(movies: MovieData...) {
        self.contents.append(contentsOf:  movies.filter {
            self.contents.contains($0) == false
        })
    }
    
    mutating func add(movies: MoviesList?) {
        guard let movies = movies else {return}
        self.contents.append(contentsOf: movies.contents.filter {
            self.contents.contains($0) == false
            }
        )
    }
    

    mutating func remove(movie: MovieData) {
        self.contents = self.contents.filter{$0 != movie}
    }
}

typealias Movies = [MovieData]

struct MovieData: Mappable {
    public var released:String?
    public var rating:String?
    public var poster:String?
    public var title:String?
    public var type:String?
    public var year:String?
    public var runtime:String?
    public var genre:String?
    public var director:String?
    public var writer:String?
    public var actors:String?
    public var plot:String?
    public var language:String?
    public var country:String?
    public var awards:String?
    public var metascore:String?
    public var imdbRating:String?
    public var imdbVotes:String?
    public var imdbID:String = ""

    
    init?(map: Map){
        
        
    }
    
    mutating func mapping(map: Map) {
        poster <- map["Poster"]
        rating <- map["Rating"]
        title <- map["Title"]
        type <- map["Type"]
        year <- map["Year"]
        released <- map["Released"]
        runtime <- map["Runtime"]
        genre <- map["Genre"]
        director <- map["Director"]
        writer <- map["Writer"]
        actors <- map["Actors"]
        plot <- map["Plot"]
        language <- map["Language"]
        country <- map["Country"]
        awards <- map["Awards"]
        metascore <- map["Metascore"]
        imdbRating <- map["imdbRating"]
        imdbVotes <- map["imdbVotes"]
        imdbID <- map["imdbID"]
        
 
    }
    
    
}
extension MovieData:Equatable {
    func isEqual(_ data: MovieData)->Bool {
        return
            self.title == data.title &&
            self.imdbID == data.imdbID
    
    }
}


extension MovieData:Hashable {
    public var hashValue: Int { return imdbID.hash}
}

func == (lhs: MovieData, rhs: MovieData)->Bool {
    return lhs.isEqual(rhs)
}

