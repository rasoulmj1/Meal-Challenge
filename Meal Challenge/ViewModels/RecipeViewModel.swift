//
//  RecipeViewModel.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import Foundation

// Define a class for the Recipe ViewModel that conforms to the ObservableObject protocol.
// ObservableObject is a type of object with a publisher that emits before the object has changed.
class RecipeViewModel: ObservableObject {
    @Published var recipes: Recipes?  // A property to hold the recipes. When it changes, it will notify any observers.
    
    // Default initializer.
    init() {}
    
    // This function is used to fetch recipes from a provided URL.
    func getRecipes() async {
        // The URL of the API endpoint is defined.
        if let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") {
            do {
                // Data is fetched asynchronously from the URL using URLSession.
                // The 'try await' keyword is used to wait until the data is fetched before moving on to the next line.
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // The JSON data is decoded into 'Recipes' object. If the data doesn't match the Recipes structure, it throws an error.
                let meals = try JSONDecoder().decode(Recipes.self, from: data)
                
                // The meals are sorted alphabetically by the meal name.
                let sortedMeals = Recipes(meals: meals.meals.sorted(by: { $0.strMeal < $1.strMeal }))

                // Since network operations are performed on a background thread,
                // we need to dispatch back to the main thread to update the 'recipes' property,
                // which is observed by the UI.
                // 'DispatchQueue.main.async ensures that the 'recipes' object is updated on the main thread.
                DispatchQueue.main.async {
                    self.recipes = sortedMeals
                }

            } catch {
                // If there's an error in fetching data or decoding, it is caught here and printed out.
                print("Failed to fetch meals: \(error)")
            }
        }
    }


    
}

