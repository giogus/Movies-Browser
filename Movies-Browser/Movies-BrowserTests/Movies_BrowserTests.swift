//
//  Movies_BrowserTests.swift
//  Movies-BrowserTests
//
//  Created by Gustavo Severo on 17/04/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import XCTest
import Nimble
@testable import Movies_Browser

class Movies_BrowserTests: XCTestCase {

    let database = Database()
    
}

// MARK: - Genres List Persistence Tests -
extension Movies_BrowserTests {
    func testClearGenresList(){
        database.clearGenresList()
        let genresList = database.getGenresList()
        expect(genresList.isEmpty) == true
    }
    func testGetGenresListAfterAddingAListOfGenres(){
        let genresArray = [Genre(id: 0, name: "Action"), Genre(id: 1, name: "Comedy"), Genre(id: 2, name: "Romance")]
        
        database.clearGenresList()
        database.setGenresList(genresList: genresArray)
        
        let genresList = database.getGenresList()
        expect(genresList.count) == 3
        expect(genresList) == genresArray
    }
    func testGetGenresListString(){
        let genresArray = [Genre(id: 0, name: "Action"), Genre(id: 1, name: "Comedy"), Genre(id: 2, name: "Romance")]
        let movie = Movie(id: 156, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [0, 1], posterPath: "")
        
        database.clearGenresList()
        database.setGenresList(genresList: genresArray)
        let genresList = database.getGenresList()
        let genresListString = database.getGenresListString(ids: movie.genreIds)
        let correctString = "\(genresList.filter({ $0.id == movie.genreIds[0] }).first!.name), \(genresList.filter({ $0.id == movie.genreIds[1] }).first!.name)"
        expect(genresListString) == correctString
    }
}

// MARK: - Genres List Request Tests -
extension Movies_BrowserTests {
    func testGenresListRequest(){
        var genresList: GenresList?
        
        Service.request(router: Router.getMoviesGenres) { (genres: GenresList?, success: Bool) in
            genresList = genres
        }
        database.setGenresList(genresList: genresList?.genres ?? [])
        expect(genresList).toEventuallyNot(beNil())
    }
    
    func testGenresListPersistenceAfterRequest(){
        waitUntil { [weak self] done in
            Service.request(router: Router.getMoviesGenres) { (genresList: GenresList?, success: Bool) in
                self?.database.setGenresList(genresList: genresList?.genres ?? [])
                done()
            }
        }
        
        let genresArray = self.database.getGenresList()
        expect(genresArray.count).toEventuallyNot(equal(0))
    }
}
