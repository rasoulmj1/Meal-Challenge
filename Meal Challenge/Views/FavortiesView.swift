//
//  FavortiesView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/27/23.
//

import SwiftUI

// Define a SwiftUI View for the favorites page.
struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel  // Observable object that serves as the ViewModel for this View.
    
    var body: some View {
        // A navigation stack is used to enable navigation between views.
        NavigationStack {
            Group{
                // Check if there are any favorite meals.
                if !viewModel.favorites.isEmpty {
                    // List each favorite meal.
                    List(viewModel.favorites, id: \.self) { mealID in
                        // Retrieve meal details using the meal ID.
                        if let meal = viewModel.getMealFromID(id: mealID) {
                            // Display a list item for each meal.
                            RecipeListItemView(recipe: meal)
                        }
                    }
                } else {
                    // Display a view indicating that there are no favorite meals.
                    EmptyFavoritesView()
                }
            }
            .navigationTitle("Favorites")  // Set the navigation title.
            // Specify the destination view when a meal is selected.
            .navigationDestination(for: Meal.self) { meal in
                RecipeDetailView(viewModel: MealViewModel(id: meal.idMeal), meal: meal)
            }
        }
    }
}

// Define a SwiftUI View to display when there are no favorite meals.
struct EmptyFavoritesView: View {
    var body: some View {
        // Vertically stack the elements with a spacing of 20.
        VStack(spacing: 20) {
            // Display a large, lightly colored star with a slash through it.
            Image(systemName: "star.slash")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray.opacity(0.4))
            
            // Display a title indicating that there are no favorite meals yet.
            Text("No Favorites Yet")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color.gray.opacity(0.6))
            
            // Provide instructions for how to add favorite meals.
            Text("Head over to the Recipes page to find ones you like 😊")
                .font(.body)
                .foregroundColor(Color.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)  // Add horizontal padding.
        }
    }
}
