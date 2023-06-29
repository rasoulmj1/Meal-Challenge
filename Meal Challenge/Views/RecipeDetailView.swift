//
//  RecipeDetailView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import SwiftUI
import CachedAsyncImage


// Define a SwiftUI View for the detailed recipe page.
struct RecipeDetailView: View {
    @ObservedObject var viewModel: MealViewModel  // Observable object that serves as the ViewModel for this View.
    @State var meal: Meal  // State object that represents the meal being displayed.
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>  // Used to control the view's presentation mode.
    
    // Gradient for UI elements, changing from blue to purple.
    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
    }
    
    // The body of the RecipeDetailView, defined as a ScrollView to accommodate content of various lengths.
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // CachedAsyncImage handles asynchronous loading and caching of images.
                CachedAsyncImage(url: meal.imageURL, content: { image in
                    image
                        .resizable()  // Make the image resizable.
                        .aspectRatio(contentMode: .fit)  // Maintain aspect ratio to prevent distortion.
                        .clipShape(RoundedRectangle(cornerRadius: 20))  // Clip to a rounded rectangle shape.
                        .padding(.top, 20)
                }, placeholder: {
                    ProgressView()  // Display a progress view until the image loads.
                })
                
                // If meal details exist, display them.
                if let details = viewModel.details?.meals.first {
                    SectionHeader(title: "Instructions")  // Header for the instructions section.
                    
                    // If instructions exist, split them by newlines and display each one.
                    if let instructionsString = details["strInstructions"],
                       let instructions = instructionsString?.split(whereSeparator: \.isNewline) {
                        
                        // Use a ForEach to iterate through the instructions.
                        ForEach(instructions.indices, id: \.self) { idx in
                            InstructionView(number: idx+1, instruction: String(instructions[idx]))
                        }
                    }
                    
                    SectionHeader(title: "Ingredients")  // Header for the ingredients section.
                    
                    // Display each ingredient and its measure, up to 20 ingredients.
                    ForEach(1..<21) { idx in
                        if let optionalIngredient = details["strIngredient\(idx)"],
                           let ingredient = optionalIngredient,
                           let optionalMeasure = details["strMeasure\(idx)"],
                           let measure = optionalMeasure,
                           !ingredient.isEmpty, !measure.isEmpty {
                            IngredientView(ingredient: ingredient, measure: measure, index: idx)
                        }
                    }
                }
                Spacer()  // Add some space at the end.
            }
            .frame(maxWidth: .infinity, alignment: .leading)  // Allow the VStack to use all available width.
        }
        .scrollIndicators(.hidden)  // Hide scroll indicators.
        .padding(.horizontal)  // Add horizontal padding.
        .navigationTitle(meal.strMeal)  // Set the navigation title.
        .navigationBarTitleDisplayMode(.inline)  // Set the navigation bar title display mode.
        .toolbar {
            // Add a favorite button to the toolbar.
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteButton(isSet: viewModel.isFavorite(meal.idMeal), action: {
                    if viewModel.isFavorite(meal.idMeal) {
                        viewModel.removeFavorite(meal.idMeal)  // Remove from favorites if it's already a favorite.
                    } else {
                        viewModel.addFavorite(meal.idMeal)  // Add to favorites if it's not already a favorite.
                    }
                })
            }
        }
    }
}

// A SwiftUI View that represents a step in a recipe instruction.
struct InstructionView: View {
    let number: Int  // The number representing the step in the recipe instruction.
    let instruction: String  // The actual instruction text.
    
    var body: some View {
        HStack {
            Text("\(number).")  // Display the number of the step.
                .fontWeight(.bold)
                .font(.title3)
            
            Text(instruction)  // Display the instruction text.
                .font(.body)
                .padding(.bottom)
            
            Spacer()
        }
        .padding()
        // Alternate background colors between gray and white.
        .background(number % 2 == 0 ? Color(.systemGray6) : Color(.systemBackground))
        .animation(.easeInOut(duration: 0.3), value: instruction)
        .transition(.slide)
    }
}

// A SwiftUI View that represents an ingredient in a recipe.
struct IngredientView: View {
    let ingredient: String  // The name of the ingredient.
    let measure: String  // The quantity or measure of the ingredient.
    let index: Int  // The position of the ingredient in the list.
    
    var body: some View {
        HStack {
            Text("\(ingredient)".capitalized)  // Display the ingredient name.
                .fontWeight(.bold)
                .font(.title3)
            
            Spacer()
            
            Text(measure)  // Display the quantity or measure of the ingredient.
        }
        .padding()
        // Alternate background colors between gray and white.
        .background(index % 2 == 0 ? Color(.systemGray6) : Color(.systemBackground))
        .animation(.easeInOut(duration: 0.3), value: ingredient)
        .transition(.slide)
    }
}

// A SwiftUI View that represents a section header in a list.
struct SectionHeader: View {
    let title: String  // The title of the section.
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.vertical)
    }
}

// A SwiftUI View that represents a favorite button.
struct FavoriteButton: View {
    @State var isSet: Bool  // A State variable that represents whether the button is set as a favorite.
    let action: () -> Void  // The action to perform when the button is pressed.
    
    @State private var animate = false  // A State variable that tracks whether the button should animate.
    
    var body: some View {
        Button(action: {
            withAnimation {
                isSet.toggle()  // Toggle the favorite status.
                action()  // Perform the associated action.
                animate = true  // Start the animation.
            }
            // Reset animation state after a delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    animate = false
                }
            }
        }) {
            Image(systemName: isSet ? "star.fill" : "star")  // Display the correct image based on the favorite status.
                .resizable()
                .foregroundColor(isSet ? .yellow : .gray)
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(animate ? 360 : 0), anchor: .center)
                // Animation configuration for the button rotation.
                .animation(animate ? Animation.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.5).repeatCount(1).speed(2) : .default, value: animate)
                .scaleEffect(animate ? 1.3 : 1.0, anchor: .center)
                // Animation configuration for the button scale.
                .animation(animate ? Animation.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.5).repeatCount(1).speed(2) : .default, value: animate)
        }
    }
}
