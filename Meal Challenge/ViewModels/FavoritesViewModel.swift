//
//  FavoritesViewModel.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/27/23.
//

import Foundation
import SwiftUI

// Define a class for the Favorites ViewModel that conforms to the ObservableObject protocol.
class FavoritesViewModel: ObservableObject {
    
    @Published var recipes: Recipes?  // A published property to hold the recipes. When it changes, it will notify any observers.
    
    // Initialize with optional Recipes object.
    init(recipes: Recipes?) {
        self.recipes = recipes
    }
    
    @AppStorage("favorites") private var favoritesString: String = ""  // Store favorite meal IDs in AppStorage to persist across app launches.
    
    // Computed property to get/set the favorites from/to the AppStorage. Values are stored as a comma-separated string and retrieved as an array.
    var favorites: [String] {
        get {
            return favoritesString.split(separator: ",").map { String($0) }
        }
        set {
            favoritesString = newValue.joined(separator: ",")
        }
    }
    
    // Function to fetch a specific Meal object by its ID.
    func getMealFromID(id: String) -> Meal? {
        if let meals = recipes?.meals {  // Check if the meals array exists.
            // Filter the meals array to match the given ID, and return the first matching Meal object if any.
            return meals.filter({ $0.idMeal == id }).first
        }
        // If no meals array exists or no match is found, return nil.
        return nil
    }
    
}
