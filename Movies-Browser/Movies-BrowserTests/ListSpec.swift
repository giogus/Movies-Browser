//
//  ListSpec.swift
//  Movies-BrowserTests
//
//  Created by gustavo.s.barros on 18/05/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import Quick
import Nimble
@testable import Movies_Browser

class ListSpec: QuickSpec {
    override func spec(){
        
        describe("browsing movies") {
            context("favorite a movie") {
                it("should favorite a movie") {
                    
                    // Arrange
                    var isFavorite: Bool = false
                    let movie = Movie(id: 0, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [], posterPath: "")
                    let viewModel = MovieDetailViewModel(movie: movie) { state in
                        isFavorite = state.isFavorite
                    }
                    
                    // Act
                    waitUntil { done in
                        viewModel.favoriteButtonWasTapped()
                        done()
                    }
                    
                    // Assert
                    expect(isFavorite).toEventually(equal(true))
                }
            }
        }

        describe("browsing moviess") {
            context("unfavorite a movie") {
                it("should unfavorite a movie") {

                    // Arrange
                    var isFavorite: Bool = false
                    let movie = Movie(id: 1, title: "Joker", releaseDate: "2020-03-20".dateFromText() ?? Date(), overview: "Lorem ipsum!", genreIds: [], posterPath: "")
                    let viewModel = MovieDetailViewModel(movie: movie) { state in
                        isFavorite = state.isFavorite
                    }

                    // Act
                    viewModel.favoriteButtonWasTapped()
                    viewModel.favoriteButtonWasTapped()

                    // Assert
                    expect(isFavorite).toEventually(equal(false))
                }
            }
        }
        
        var database: Database!
        beforeEach {
            database = Database()
        }
        describe("browsing movies") {
            context("select a movie") {
                it("should show the movie info") {
                    
                    let movie = Movie(id: 0, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [], posterPath: "")
                    let viewModel = MovieDetailViewModel(movie: movie, callback: nil)
                    viewModel.callback = { state in
                        expect(state.isFavorite) == database.isFavorited(id: movie.id)
                        expect(state.titleText) == movie.title
                        expect(state.descriptionText) == movie.overview
                        expect(state.releaseDateText) == movie.releaseDate.year
                        expect(state.genreListText) == database.getGenresListString(ids: movie.genreIds)
                    }
                }
            }
        }
    }
}
