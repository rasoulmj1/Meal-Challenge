//
//  RecipeListView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/27/23.
//

import SwiftUI
import CachedAsyncImage

// Define a SwiftUI View for a recipe list item.
struct RecipeListItemView: View {
    @State var recipe: Meal  // State object that represents the recipe for this list item.
    
    var body: some View {
        // A navigation link that navigates to the detailed view for this recipe.
        NavigationLink(value: recipe) {
            // Horizontally stack the elements with a spacing of 15.
            HStack(spacing: 15) {
                // CachedAsyncImage handles asynchronous loading and caching of images.
                CachedAsyncImage(url: recipe.imageURL, content: { image in
                    image.resizable()  // Make the image resizable.
                        .aspectRatio(contentMode: .fill)  // Fill the frame while maintaining aspect ratio.
                        .frame(width: 50, height: 50)  // Specify the frame size.
                        .clipShape(RoundedRectangle(cornerRadius: 5))  // Clip to a rounded rectangle shape.
                    
                },
                                 placeholder: {
                    // Use a placeholder image until the actual image loads.
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .resizable()  // Make the placeholder image resizable.
                        .frame(width: 50, height: 50)  // Specify the frame size.
                })
                
                // Display the recipe name.
                Text(recipe.strMeal)
            }
        }
    }
}

// A preview provider for RecipeListItemView, used to generate previews in Xcode's SwiftUI preview.
struct RecipeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        // Generate a preview with a placeholder recipe.
        RecipeListItemView(recipe: Meal(strMeal: "", strMealThumb: "", idMeal: ""))
    }
}

