//
//  Recipes.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import Foundation

// Define a structure to map the JSON response from the API for recipes.
struct Recipes: Codable {
    let meals: [Meal]  // An array to store all the meals.
}

// Define a structure for each individual meal.
struct Meal: Codable, Hashable {
    let strMeal: String  // The meal's name.
    let strMealThumb: String  // The URL for the meal's thumbnail image.
    let idMeal: String  // The meal's ID.
}

// Define a structure to map the JSON response from the API for recipe details.
struct RecipeDetails: Codable {
    let meals: [[String: String?]]  // A nested array to store all the meals and their details.
}

// Extend the Meal structure to add a computed property for the image URL.
extension Meal {
    var imageURL: URL {
        return URL(string: self.strMealThumb)!  // Convert the thumbnail string to a URL.
    }
}

