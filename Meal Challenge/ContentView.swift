//
//  ContentView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import SwiftUI

// Define the ContentView, conforming to the View protocol.
struct ContentView: View {
    @ObservedObject var viewModel: RecipeViewModel = .init()  // Define the observable object view model.
    @State var search: String = ""  // Define a state variable for the search string.
    @State private var showFavorites = false  // Define a state variable to track whether to show the favorites view.
    
    // Define the body of the ContentView.
    var body: some View {
        NavigationStack {  // Create a navigation stack.
            if let recipes = viewModel.recipes {  // If recipes exist.
                List(recipes.meals.filter({search.isEmpty ? true : $0.strMeal.contains(search)}), id: \.idMeal){ recipe in
                   // Create a list of recipe items, filtered by the search string.
                   RecipeListItemView(recipe: recipe)  // Use the RecipeListItemView for each recipe.
                }
                .navigationDestination(for: Meal.self, destination: { meal in
                    // Define the navigation destination when a meal is selected.
                    RecipeDetailView(viewModel: MealViewModel(id: meal.idMeal), meal: meal)
                })
                .navigationTitle("Desserts")  // Set the navigation title.
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // Add a button to the toolbar to toggle the favorites view.
                        Button(action: { showFavorites.toggle() }) {
                            Image(systemName: "star.fill")
                        }
                    }
                }
                .searchable(text: $search)  // Make the list searchable.
            }
        }
        .task {
            // Fetch the recipes when the ContentView appears.
            await viewModel.getRecipes()
        }
        .sheet(isPresented: $showFavorites) {
            // Show the favorites view as a sheet when showFavorites is true.
            FavoritesView(viewModel: FavoritesViewModel(recipes: viewModel.recipes))
        }
    }
}

// Provide a preview for the ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

