//
//  ContentView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: RecipeViewModel = .init()
    @State var search: String = ""
    @State private var showFavorites = false
    
    var body: some View {
        NavigationStack {
            if let recipes = viewModel.recipes {
                List(recipes.meals.filter({search.isEmpty ? true : $0.strMeal.contains(search)}), id: \.idMeal){ recipe in
                   RecipeListItemView(recipe: recipe)
                }
                .navigationDestination(for: Meal.self, destination: { meal in
                    RecipeDetailView(viewModel: MealViewModel(id: meal.idMeal), meal: meal)
                })
                .navigationTitle("Desserts")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showFavorites.toggle() }) {
                            Image(systemName: "star.fill")
                        }
                    }
                }
                .searchable(text: $search)
            }
        }
        .task {
            viewModel.recipes = await viewModel.getRecipes()
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView(viewModel: FavoritesViewModel(recipes: viewModel.recipes))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
