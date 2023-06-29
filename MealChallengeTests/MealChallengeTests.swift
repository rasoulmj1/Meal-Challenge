//
//  MealChallengeTests.swift
//  MealChallengeTests
//
//  Created by Mj Rasoul on 6/28/23.
//

import XCTest
@testable import Meal_Challenge

final class MealChallengeTests: XCTestCase {

//    override func setUpWithError() throws {
//
//    }

    @MainActor override func tearDownWithError() throws {

        let viewModel = MealViewModel(id: "testId")
        viewModel.favorites.removeAll()
    }

    @MainActor func testAddAndRemoveFavorite() throws {
        let viewModel = MealViewModel(id: "testId")
        

        viewModel.addFavorite("testId")
        

        XCTAssertTrue(viewModel.favorites.contains("testId"), "The test ID should be added to favorites")
    
        viewModel.removeFavorite("testId")
        
        XCTAssertFalse(viewModel.favorites.contains("testId"), "The test ID should be removed from favorites")
    }
    
    func testGetMealFromID() async throws {
        let recipes = Recipes(meals: [Meal(strMeal: "testMeal", strMealThumb: "testUrl", idMeal: "testId")])
        let viewModel = FavoritesViewModel(recipes: recipes)
        
        let meal = viewModel.getMealFromID(id: "testId")
        
        XCTAssertNotNil(meal, "The meal should not be nil")
        XCTAssertEqual(meal?.idMeal, "testId", "The returned meal id should match the queried id")
    }

    func testMealImageURL() throws {
        let meal = Meal(strMeal: "testMeal", strMealThumb: "https://example.com", idMeal: "testId")
        XCTAssertEqual(meal.imageURL, URL(string: "https://example.com"), "The imageURL should match the given URL string")
    }

    func testDecodingRecipes() throws {
        let json = """
            {
                "meals": [
                    {
                        "strMeal": "testMeal",
                        "strMealThumb": "https://example.com",
                        "idMeal": "testId"
                    }
                ]
            }
        """.data(using: .utf8)!
        
        let recipes = try JSONDecoder().decode(Recipes.self, from: json)
        
        XCTAssertEqual(recipes.meals.count, 1, "There should be one meal in the decoded Recipes")
        XCTAssertEqual(recipes.meals.first?.strMeal, "testMeal", "The first meal's name should be 'testMeal'")
    }

    

}

