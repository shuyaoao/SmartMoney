//
//  CategoryData.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import Foundation
import UIKit
import SwiftUI

// MARK: Default Category Struct
struct Category: Identifiable {
    let id: Int
    let category: String
    let icon : Image
    var selected = false
    var selectedColor = Color(.systemTeal)
    
    // Default Category
    init(id: Int, category: String, icon: Image) {
        self.id = id
        self.category = category
        self.icon = icon
        self.selected = false
        self.selectedColor = Color(.systemTeal)
    }
    
    // Selected Category Selection
    init(id: Int, category: String, icon: Image, selected: Bool, selectedColor: Color) {
        self.id = id
        self.category = category
        self.icon = icon
        self.selected = selected
        self.selectedColor = selectedColor
    }
    
    func buttonSelected() -> Category {
        return Category(id: self.id, category: self.category, icon: self.icon, selected: true, selectedColor: Color(.systemPink))
        
    }
    
    func buttonunSelected() -> Category {
        return Category(id: self.id, category: self.category, icon: self.icon)
    }
}

// MARK: Class to Handle A Vertical Stack of Categories (3 in one Stack)
struct CategoryStack: Identifiable {
    let id : Int
    var first : Category
    var second: Category
    var third : Category
}

// MARK: Main Category Data Model
class CategoryDataModel : ObservableObject {
    @Published var listofCategories : [Category]
    
    init(listofCategories: [Category]) {
        self.listofCategories = listofCategories
    }
}


// MARK: Category Data Source
var catDataSource = CategoryDataModel(listofCategories: [foodCategory, transportCategory, groceriesCategory, entertainmentCategory, utilitiesCategory, clothingCategory, healthCategory, workCategory, taxCategory, insuranceCategory, educationCategory])


// MARK: Categories
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




