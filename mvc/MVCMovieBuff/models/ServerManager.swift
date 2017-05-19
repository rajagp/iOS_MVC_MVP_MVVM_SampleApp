//
//  ServerManager.swift
//  MovieBuff
//
//  Created by Priya Rajagopal on 10/2/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//


import Foundation
import AlamofireObjectMapper
import Alamofire
import OHHTTPStubs

public enum ServerErrorCodes:Int {
    case noMoreMovies = 10001
    case genericError = 20001
    
}

public enum ServerErrorMessages:String {
    case noMoreMovies = "No More Movies"
    case genericError = "Unknown Server Error"
    
}


public enum ServerError: Error {
    
    case systemError(Error)
    case customError(String)
    // add http status errors
    public var details:(code:Int, message:String){
        switch self {
        case .customError(let errorMesg):
            switch errorMesg {
            case "Movie not found!":
                return (ServerErrorCodes.noMoreMovies.rawValue,ServerErrorMessages.noMoreMovies.rawValue)
            default:
                return (ServerErrorCodes.genericError.rawValue,ServerErrorMessages.genericError.rawValue)
            }
        case .systemError(let errCode) :
            return (errCode._code,errCode.localizedDescription)
            
        }
    }
}

public struct ServerManager {
    
    static let sharedInstance = ServerManager()
    
    weak var moviesStub: OHHTTPStubsDescriptor?
    
    var enableStub:Bool = false
    
    init() {
        enableStub = false
        checkAndEnableSTUBServer()
        
    }
    
   func searchForMatchesWithTitle(_ title:String, ofType type:String?, andYear year:String?,atPage page:Int,handler:@escaping (Movies?,ServerError?)->Void) {
        
        Alamofire.request(ServerRequestRouter.searchByTitle(title, type, year,page))
            .validate()
            .responseArray(keyPath:"Search") {(response:DataResponse<Movies>) in
                
                switch response.result {
                    
                case .success:
                    if let movies = response.result.value  {
                    
                        print (movies)
                        handler(movies, nil)
                        
                    }
                case .failure(let error):
                    print(error)
                    let request = response.request
                    // Ugly code Alert!
                    // There is no clean way to distinguish between case when data is not fetched when no more
                    // pages versus when there is no matching data at all
                    // Use page=1 to distinguish between case when there is no movies at all
                    // meeting criteria or if there are no more movies to be paged in
                    // ALso ideally response should include the requested page.
                    
                    let queryComponents = request?.url?.query?.components(separatedBy: "&")
                    let isFirstPage:Bool = queryComponents?.filter({
                        $0.trimmingCharacters(in: .whitespaces) == "page=1"
                    }).count != 0
                    
                    if isFirstPage {
                        handler(nil,ServerError.customError(ServerErrorMessages.genericError.rawValue))
                        
                    }
                    else {
                        handler(nil,ServerError.customError(ServerErrorMessages.noMoreMovies.rawValue))
                        
                    }
                    
                }
        }
    
    }
    func detailsWithIMDBID(_ imdbID:String ,handler:@escaping (MovieData?,NSError?)->Void) {
        Alamofire.request(ServerRequestRouter.detailsByIMDBID(imdbID))
            .validate()
            .responseObject{(response:DataResponse<MovieData>) in
                
                switch response.result {
                case .success:
                    if let movie = response.result.value  {
                        
                        print (movie)
                        handler(movie, nil)
                        
                    }
                case .failure(let error):
                    print(error)
                    handler(nil,error as NSError?)
                    
                }
        }
        
    }
    
}


// MARK: Stub. 
extension ServerManager {
    fileprivate func checkAndEnableSTUBServer() {
        let testMode = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"]
        
        guard testMode != nil  else {return}
        loadMoviesStub()
        loadMovieDetaisStub()
    }
    
    private func loadMoviesStub() {
       
        print("\(#function) Use stub server")
        // Swift
        let schemeStub = isScheme("https")
        let hostStub = isHost("www.omdbapi.com")
        let queryStub = containsQueryParams(["plot": "short","r":"json","s":"jaws","type":"Movie"])
        stub(condition: hostStub && queryStub && schemeStub) { request in
            
            let testBundle = Bundle.main
            let moviesFile = testBundle.path(forResource: "movies", ofType: "json")
            
            return OHHTTPStubsResponse(
              
                fileAtPath: moviesFile!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
 
        }
    }
    
    private func loadMovieDetaisStub() {
        // Swift
          
        print("\(#function) Use stub server")
        let schemeStub = isScheme("https")
        let hostStub = isHost("www.omdbapi.com")
        let queryStub = containsQueryParams(["plot": "full","r":"json","i":"tt0077766"])
        stub(condition: hostStub && queryStub && schemeStub) { request in
            let testBundle = Bundle.main
            let moviesFile = testBundle.path(forResource: "moviedetails", ofType: "json")
            
            return OHHTTPStubsResponse(
                
                fileAtPath: moviesFile!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
            
        }
    }
}


