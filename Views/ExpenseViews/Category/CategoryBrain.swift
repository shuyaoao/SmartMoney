//
//  CategoryData.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import Foundation
import UIKit
import SwiftUI

struct CategoryBrain {
    let selectedCategory : Category
    
}


// MARK: Default Category Class
struct Category: Identifiable {
    let id: Int
    let category: String
    let icon : Image
    var selected = false
    var selectedColor = Color(.systemTeal)
    
    mutating func buttonSelected() {
        selected = true
        selectedColor = Color(.systemPink)
    }
    
    mutating func buttonunSelected() {
        selected = false
        selectedColor = Color(.systemTeal)
    }
}

// MARK: Class to Handle A Vertical Stack of Categories (3 in one Stack)
struct CategoryStack: Identifiable {
    let id : Int
    let stack : [Category]
}

// MARK: Data Source
var foodCategory = Category(id: 0, category: "Food", icon: Image("food"))
var transportCategory = Category(id: 1, category: "Transport", icon: Image("transport"))
var groceriesCategory = Category(id: 2, category: "Groceries", icon: Image("groceries"))
var entertainmentCategory = Category(id: 3, category: "Entertainment", icon: Image("entertainment"))
var utilitiesCategory = Category(id: 4, category: "Utilities", icon: Image("utilities"))
var clothingCategory = Category(id: 5, category: "Clothing", icon: Image("tshirt.fill"))
var healthCategory = Category(id: 6, category: "Health", icon: Image("health"))
var workCategory = Category(id: 7, category: "Work", icon: Image("work"))
var taxCategory = Category(id: 8, category: "Tax", icon: Image("tax"))
var insuranceCategory = Category(id: 9, category: "Insurance", icon: Image("insurance"))
var educationCategory = Category(id: 10, category: "Education", icon: Image("education"))

// Filler Category
var unfilledCategory = Category(id: 11, category: "", icon: Image("questionmark"))


var listCatStack = [CategoryStack(id: 0 , stack: [foodCategory, transportCategory, groceriesCategory]),
                    CategoryStack(id: 1 , stack: [entertainmentCategory, utilitiesCategory, clothingCategory]),
                    CategoryStack(id: 2 , stack: [healthCategory, workCategory, taxCategory]),
                    CategoryStack(id: 3 , stack: [insuranceCategory, educationCategory, unfilledCategory])]




