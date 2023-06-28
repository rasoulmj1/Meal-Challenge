//
//  RecipeDetailView.swift
//  Meal Challenge
//
//  Created by Mj Rasoul on 6/23/23.
//

import SwiftUI
import CachedAsyncImage


struct RecipeDetailView: View {
    @ObservedObject var viewModel: MealViewModel
    @State var meal: Meal
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                
                CachedAsyncImage(url: meal.imageURL, content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.top, 20)
                }, placeholder: {
                    ProgressView()
                })
                
                
                if let details = viewModel.details?.meals.first {
                    SectionHeader(title: "Instructions")
                    
                    if let instructionsString = details["strInstructions"],
                       let instructions = instructionsString?.split(whereSeparator: \.isNewline) {
                        
                        ForEach(instructions.indices, id: \.self) { idx in
                            InstructionView(number: idx+1, instruction: String(instructions[idx]))
                        }
                    }
                    
                    SectionHeader(title: "Ingredients")
                    
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
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .navigationTitle(meal.strMeal)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteButton(isSet: viewModel.isFavorite(meal.idMeal), action: {
                    if viewModel.isFavorite(meal.idMeal) {
                        viewModel.removeFavorite(meal.idMeal)
                    } else {
                        viewModel.addFavorite(meal.idMeal)
                    }
                })
            }
        }
    }
}

struct InstructionView: View {
    let number: Int
    let instruction: String
    
    var body: some View {
        HStack {
            Text("\(number).")
                .fontWeight(.bold)
                .font(.title3)
            
            Text(instruction)
                .font(.body)
                .padding(.bottom)
            
            Spacer()
        }
        .padding()
        .background(number % 2 == 0 ? Color(.systemGray6) : Color(.systemBackground))
        .animation(.easeInOut(duration: 0.3), value: instruction)
        .transition(.slide)
    }
}

struct IngredientView: View {
    let ingredient: String
    let measure: String
    let index: Int
    
    var body: some View {
        HStack {
            Text("\(ingredient)".capitalized)
                .fontWeight(.bold)
                .font(.title3)
            
            Spacer()
            
            Text(measure)
        }
        .padding()
        .background(index % 2 == 0 ? Color(.systemGray6) : Color(.systemBackground))
        .animation(.easeInOut(duration: 0.3), value: ingredient)
        .transition(.slide)
    }
}


struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.vertical)
    }
}

struct FavoriteButton: View {
    @State var isSet: Bool
    let action: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                isSet.toggle()
                action()
                animate = true
            }
            // reset animation state after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    animate = false
                }
            }
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .resizable()
                .foregroundColor(isSet ? .yellow : .gray)
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(animate ? 360 : 0), anchor: .center)
                .animation(animate ? Animation.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.5).repeatCount(1).speed(2) : .default, value: animate)
                .scaleEffect(animate ? 1.3 : 1.0, anchor: .center)
                .animation(animate ? Animation.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.5).repeatCount(1).speed(2) : .default, value: animate)
        }
    }
}



