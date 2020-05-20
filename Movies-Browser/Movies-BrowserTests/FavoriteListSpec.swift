//
//  FavoriteListSpec.swift
//  Movies-BrowserTests
//
//  Created by gustavo.s.barros on 19/05/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import Quick
import Nimble
@testable import Movies_Browser

class FavoriteListSpec: QuickSpec {
    override func spec(){
        
        let database = Database()
        describe("browsing favorites movies") {
            context("unfavorite all movies") {
                it("should show a empty list") {
                    // Arrange & Act
                    database.clearFavoritesList()
                    let favoritesList = database.getFavoritesList()
                    
                    // Assert
                    expect(favoritesList.isEmpty) == true
                }
            }
        }
        
        describe("browsing favorites movies") {
            context("a movie is add as favorite") {
                it("should show the favorites list with a movie") {
                    // Arrange
                    let movie = Movie(id: 156, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [5, 25], posterPath: "")
                    
                    // Act
                    database.clearFavoritesList()
                    database.addNewFavorite(movie: movie)
                    
                    // Assert
                    let favoritesList = database.getFavoritesList()
                    expect(favoritesList.count) == 1
                    expect(favoritesList[0]) == movie
                }
            }
        }
        
        describe("browsing favorites movies") {
            context("a movie is unfavorited") {
                it("should show the favorites list with a movie") {
                    // Arrange
                    let firstMovie = Movie(id: 156, title: "Batman", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum", genreIds: [5, 25], posterPath: "")
                    let secondMovie = Movie(id: 240, title: "Batman II", releaseDate: "2020-04-20".dateFromText() ?? Date(), overview: "Lorem ipsum II", genreIds: [40], posterPath: "")
                    database.clearFavoritesList()
                    database.addNewFavorite(movie: firstMovie)
                    database.addNewFavorite(movie: secondMovie)
                    
                    // Act & Assert
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
        }
    }
}
