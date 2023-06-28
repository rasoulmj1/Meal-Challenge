//
//  FavortiesView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/27/23.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            Group{
                if !viewModel.favorites.isEmpty {
                    List(viewModel.favorites, id: \.self) { mealID in
                        if let meal = viewModel.getMealFromID(id: mealID) {
                            RecipeListItemView(recipe: meal)
                        }
                    }
                } else {
                    EmptyFavoritesView()
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Meal.self) { meal in
                RecipeDetailView(viewModel: MealViewModel(id: meal.idMeal), meal: meal)
            }
        }
    }
}


struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.slash")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray.opacity(0.4))
            
            Text("No Favorites Yet")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color.gray.opacity(0.6))
            
            Text("Head over to the Recipes page to find ones you like 😊")
                .font(.body)
                .foregroundColor(Color.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
    }
}
