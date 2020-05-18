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
    
    // MARK: - Movie Detail Tests -
    func testFavoriteActionInMovieDetail() {
        var isFavorite: Bool = false
        let movie = Movie(id: 0, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [], posterPath: "")
        let viewModel = MovieDetailViewModel(movie: movie) { state in
            isFavorite = state.isFavorite
        }
        viewModel.favoriteButtonWasTapped()
        expect(isFavorite) == true
    }

    func testUnfavoriteActionInMovieDetail() {
        var isFavorite: Bool = false
        let movie = Movie(id: 0, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [], posterPath: "")
        let viewModel = MovieDetailViewModel(movie: movie) { state in
            isFavorite = state.isFavorite
        }
        viewModel.favoriteButtonWasTapped()
        viewModel.favoriteButtonWasTapped()
        expect(isFavorite) == false
    }
    
    func testDataPresentationOnMovieDetail() {
        let movie = Movie(id: 0, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [], posterPath: "")
        let viewModel = MovieDetailViewModel(movie: movie, callback: nil)
        viewModel.callback = { [weak self] state in
            expect(state.isFavorite) == self?.database.isFavorited(id: movie.id)
            expect(state.titleText) == movie.title
            expect(state.descriptionText) == movie.overview
            expect(state.releaseDateText) == movie.releaseDate.year
            expect(state.genreListText) == self?.database.getGenresListString(ids: movie.genreIds)
        }
    }
}

// MARK: - Favorites List Persistence Tests -
extension Movies_BrowserTests {
    func testClearFavoritesList(){
        database.clearFavoritesList()
        let favoritesList = database.getFavoritesList()
        expect(favoritesList.isEmpty) == true
    }
    
    func testGetFavoritesListAfterAddingOneMovie(){
        let movie = Movie(id: 156, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [5, 25], posterPath: "")
        
        database.clearFavoritesList()
        database.addNewFavorite(movie: movie)
        
        let favoritesList = database.getFavoritesList()
        expect(favoritesList.count) == 1
        expect(favoritesList[0]) == movie
    }
    
    func testGetFavoritesListAfterRemovingOneMovie(){
        let firstMovie = Movie(id: 156, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [5, 25], posterPath: "")
        let secondMovie = Movie(id: 240, title: "Batman II", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum II", genreIds: [40], posterPath: "")
        
        database.clearFavoritesList()
        database.addNewFavorite(movie: firstMovie)
        database.addNewFavorite(movie: secondMovie)
        
        var favoritesList = database.getFavoritesList()
        expect(favoritesList.count) == 2
        expect(favoritesList[0]) == firstMovie
        expect(favoritesList[1]) == secondMovie
        
        database.deleteFavorite(id: secondMovie.id)
        favoritesList = database.getFavoritesList()
        expect(favoritesList.count) == 1
        expect(favoritesList[0]) == firstMovie
    }
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
