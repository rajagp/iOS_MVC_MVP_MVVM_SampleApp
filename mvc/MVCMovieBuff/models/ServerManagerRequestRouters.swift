//
//  ServerManagerRequestRouters.swift
//  ServerDataManager
//
//  Created by Priya Rajagopal
//  Copyright (c) 2014 Invicara Inc. All rights reserved.
//

import Foundation
import Alamofire



// Routes XOSPassport related requests
internal enum ServerRequestRouter: URLRequestConvertible {
    
    static var baseURLString:String {
        return "https://www.omdbapi.com/"
    }
  
    static var apiKey:String {
        return <#Get Key from https://www.patreon.com/posts/api-is-going-10743518 #>
    }
    case searchByTitle(String,String?,String?,Int)
    case detailsByIMDBID(String)
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .searchByTitle(_):
            return .get
        case .detailsByIMDBID(_):
            return .get
       
        }
        
    }
    
    var path: String {
        switch self {
        case .searchByTitle(_):
            return "\(ServerRequestRouter.baseURLString)"
        case .detailsByIMDBID(_):
            return "\(ServerRequestRouter.baseURLString)"
            
        }
    }
    
       // MARK: URLRequestConvertible
    
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    public func asURLRequest() throws -> URLRequest {
        //  guard  let urlString = ServerRequestRouter.baseURLString else {return NSMutableURLRequest()}
        //
        //        let result: (path: String, method: Alamofire.Method, parameters: [String: AnyObject]) = {
        //            switch self {
        //            case .SignInUser(let params):
        //                return (  "xospassport/api/\(XOSRouter.APIVersion)/users/signin", .POST, params)
        //
        //            }
        //        }()
        
        
        
        
        let URL = Foundation.URL(string: path)!
        
        var mutableURLRequest = URLRequest(url:URL)
        mutableURLRequest.httpMethod = httpMethod.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
       
            
        case .searchByTitle(let searchStr,let type,let year,let page):
            
            do {
                var params:[String:AnyObject] = ["s":searchStr as AnyObject ]
                params["r"] = "json" as AnyObject
                params["plot"] = "short" as AnyObject
                if let type = type  {
                     params["type"] = type as AnyObject
                }
                if let year = year  {
                    params["y"] = year as AnyObject
                }
                params["page"] = page as AnyObject
                params["apikey"] = ServerRequestRouter.apiKey as AnyObject
                let encoding =  URLEncoding(destination: URLEncoding.Destination.queryString)
                return try encoding.encode(mutableURLRequest, with:params)
                
            } catch {
                // No-op
                return mutableURLRequest
            }
            
        case .detailsByIMDBID(let id):
            do {
                var params:[String:AnyObject] = ["i":id as AnyObject ]
                params["r"] = "json" as AnyObject
                params["plot"] = "full" as AnyObject
                params["apikey"] = ServerRequestRouter.apiKey as AnyObject
                let encoding =  URLEncoding(destination: URLEncoding.Destination.queryString)
                return try encoding.encode(mutableURLRequest, with:params)
                
            } catch {
                // No-op
                return mutableURLRequest
            }
            
    }
}


    
    
    
}

