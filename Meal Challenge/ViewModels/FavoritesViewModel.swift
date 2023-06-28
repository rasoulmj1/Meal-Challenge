//
//  FavoritesViewModel.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/27/23.
//

import Foundation
import SwiftUI

class FavoritesViewModel: ObservableObject {
    
    @Published var recipes: Recipes?
    
    init(recipes: Recipes?) {
        self.recipes = recipes
    }

    @AppStorage("favorites") private var favoritesString: String = ""
    
    var favorites: [String] {
        get {
            return favoritesString.split(separator: ",").map { String($0) }
        }
        set {
            favoritesString = newValue.joined(separator: ",")
        }
    }
    
    func getMealFromID(id: String) -> Meal? {
        if let meals = recipes?.meals {
            return meals.filter({ $0.idMeal == id }).first
        }
        return nil
    }
    
}
