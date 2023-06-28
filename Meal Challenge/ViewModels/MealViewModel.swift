//
//  MealViewModel.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import SwiftUI
import Foundation

@MainActor class MealViewModel: ObservableObject {
    @Published var details: RecipeDetails?

    @AppStorage("favorites") private var favoritesString: String = ""
    
    var favorites: [String] {
        get {
            return favoritesString.split(separator: ",").map { String($0) }
        }
        set {
            favoritesString = newValue.joined(separator: ",")
        }
    }
    
    private var id: String
    
    init(id: String) {
        self.id = id
        Task {
            self.details = await getDetails()
        }
    }
    
    
    func getDetails() async -> RecipeDetails? {
            let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!
            return try? await URLSession.shared.decode(RecipeDetails.self, from: url)
        }
    
    func addFavorite(_ id: String) {
        if !favorites.contains(id) {
            favorites.append(id)
        }
    }

    func removeFavorite(_ id: String) {
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
        }
    }

    func isFavorite(_ id: String) -> Bool {
        return favorites.contains(id)
    }
    
}
