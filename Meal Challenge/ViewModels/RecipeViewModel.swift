//
//  RecipeViewModel.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: Recipes?
    
    init() {}
    
    func getRecipes() async -> Recipes? {
            let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
            return try? await URLSession.shared.decode(Recipes.self, from: url)
        }
    
}
