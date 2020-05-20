//
//  GenresListSpec.swift
//  Movies-BrowserTests
//
//  Created by gustavo.s.barros on 19/05/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import Quick
import Nimble
@testable import Movies_Browser

class GenresListSpec: QuickSpec {
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
    }
}
