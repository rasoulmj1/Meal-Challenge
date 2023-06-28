//
//  RecipeListView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/27/23.
//

import SwiftUI
import CachedAsyncImage

struct RecipeListItemView: View {
    @State var recipe: Meal
    
    var body: some View {
        NavigationLink(value: recipe) {
            HStack(spacing: 15) {
                CachedAsyncImage(url: recipe.imageURL, content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                },
                           placeholder: {
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                })
                
                Text(recipe.strMeal)
            }
        }
    }
}

struct RecipeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListItemView(recipe: Meal(strMeal: "", strMealThumb: "", idMeal: ""))
    }
}
