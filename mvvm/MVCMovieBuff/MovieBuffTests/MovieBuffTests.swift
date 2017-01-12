//
//  MovieBuffTests.swift
//  MovieBuffTests
//
//  Created by Priya Rajagopal on 12/16/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import XCTest

@testable import MovieBuff

class MovieBuffTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        let app = XCUIApplication()
//        app.launchArguments = ["TestMode"]
//        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFetchListOfMovies() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation:XCTestExpectation = self.expectation(description: "Fetch Movies")
        
        let _ = ServerManager.sharedInstance.searchForMatchesWithTitle( "Jaws", ofType:"Movie", andYear :nil, atPage:1) { (movies, error) in
            expectation.fulfill()
            XCTAssertNil(error)
            XCTAssertEqual(movies?.count, 10)
            print("Movies fetched: \(movies)")
        }
        
        self.waitForExpectations(timeout: 30, handler:{ error in
            
            print ("Fetched data")
            
            
        })
        
    }
    
    func testFetchMovieDetails() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation:XCTestExpectation = self.expectation(description: "Fetch Movie Details")
        
        let _ = ServerManager.sharedInstance.detailsWithIMDBID("tt0077766") { (movie, error) in
            expectation.fulfill()
            XCTAssertNil(error)
            XCTAssertEqual(movie?.imdbID, "tt0077766")
            print("Movie fetched: \(movie)")
        }
        
        self.waitForExpectations(timeout: 30, handler:{ error in
            
            print ("Fetched data")
        
            
        })
        
    }
    
    
}
