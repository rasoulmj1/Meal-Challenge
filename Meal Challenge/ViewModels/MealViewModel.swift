//
//  MealViewModel.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import SwiftUI
import Foundation

// Define a class for the Meal ViewModel that conforms to the ObservableObject protocol.
// @MainActor ensures this class operates on the main actor (main queue/thread).
@MainActor class MealViewModel: ObservableObject {
    @Published var details: RecipeDetails?  // A published property to hold the details of a recipe. When it changes, it will notify any observers.
    
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
    
    private var id: String  // ID of the meal.
    
    // Initializer takes the meal ID, stores it, and fetches the meal details.
    init(id: String) {
        self.id = id
        Task {
            self.details = await getDetails()  // Fetch the details for this meal.
        }
    }
    
    // Asynchronous function to fetch meal details from the API.
    func getDetails() async -> RecipeDetails? {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!  // Create a URL object with the API endpoint.
        return try? await URLSession.shared.decode(RecipeDetails.self, from: url)  // Try to decode the JSON response into a RecipeDetails object.
    }
    
    // Function to add a meal ID to the favorites.
    func addFavorite(_ id: String) {
        if !favorites.contains(id) {  // Add the meal ID only if it's not already in the favorites.
            favorites.append(id)
        }
    }
    
    // Function to remove a meal ID from the favorites.
    func removeFavorite(_ id: String) {
        if let index = favorites.firstIndex(of: id) {  // Remove the meal ID only if it exists in the favorites.
            favorites.remove(at: index)
        }
    }
    
    // Function to check if a meal ID is in the favorites.
    func isFavorite(_ id: String) -> Bool {
        return favorites.contains(id)  // Return true if the meal ID is in the favorites; false otherwise.
    }
}

