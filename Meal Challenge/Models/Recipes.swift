//
//  Recipes.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import Foundation

struct Recipes: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Hashable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct RecipeDetails: Codable {
    let meals: [[String: String?]]
}

extension Meal {
    var imageURL: URL {
        return URL(string: self.strMealThumb)!
    }
}
