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
class Category: Identifiable, ObservableObject {
    let id: Int
    let category: String
    let icon : Image
    @Published var selected = false
    @Published var selectedColor = Color.init("Medium Blue") {
        didSet {
            objectWillChange.send()
        }
    }
    
    let imageName: String
    
    // Default Category
    init(id: Int, category: String, icon: Image, imageName: String) {
        self.id = id
        self.category = category
        self.icon = icon
        self.selected = false
        self.selectedColor = Color.init("Medium Blue")
        self.imageName = imageName
    }
    
    // Selected Category Selection
    init(id: Int, category: String, icon: Image, selected: Bool, selectedColor: Color, imageName: String) {
        self.id = id
        self.category = category
        self.icon = icon
        self.selected = selected
        self.selectedColor = selectedColor
        self.imageName = imageName
    }
    
    func buttonSelected() -> Category {
        return Category(id: self.id, category: self.category, icon: self.icon, selected: true, selectedColor: Color(.systemPink), imageName: self.imageName)
        
    }
    
    func buttonunSelected() -> Category {
        return Category(id: self.id, category: self.category, icon: self.icon, imageName: self.imageName)
    }
}

// MARK: Class to Handle A Vertical Stack of Categories (3 in one Stack)
class CategoryStack: Identifiable, ObservableObject {
    let id : Int
    @Published var first : Category
    @Published var second: Category
    @Published var third : Category
    
    init(id: Int, first: Category, second: Category, third: Category) {
        self.id = id
        self.first = first
        self.second = second
        self.third = third
    }
}

// MARK: Main Category Data Model
class CategoryDataModel : ObservableObject {
    @Published var listofCategories : [Category]
    
    init(listofCategories: [Category]) {
        self.listofCategories = listofCategories
    }
}


// MARK: Category Data Source
var catDataSource = CategoryDataModel(listofCategories: [foodCategory, transportCategory, groceriesCategory, entertainmentCategory, utilitiesCategory, clothingCategory, healthCategory, workCategory, taxCategory, insuranceCategory, educationCategory, othersCategory])


// MARK: Categories

var categoryDict = [
    "Food" : foodCategory,
    "Transport" : transportCategory,
    "Groceries" : groceriesCategory,
    "Entertainment" : entertainmentCategory,
    "Utilities" : utilitiesCategory,
    "Clothing" : clothingCategory,
    "Health" : healthCategory,
    "Work" : workCategory,
    "Tax" : taxCategory,
    "Insurance" : insuranceCategory,
    "Education" : educationCategory,
    "Others" : othersCategory
]

var foodCategory = Category(id: 0, category: "Food", icon: Image("food"), imageName: "takeoutbag.and.cup.and.straw.fill")
var transportCategory = Category(id: 1, category: "Transport", icon: Image("transport"), imageName: "train.side.rear.car")
var groceriesCategory = Category(id: 2, category: "Groceries", icon: Image("groceries"), imageName: "bag.circle")
var entertainmentCategory = Category(id: 3, category: "Entertainment", icon: Image("entertainment"), imageName: "popcorn.circle")
var utilitiesCategory = Category(id: 4, category: "Utilities", icon: Image("utilities"), imageName: "house.circle")
var clothingCategory = Category(id: 5, category: "Clothing", icon: Image("tshirt.fill"), imageName: "tshirt.fill")
var healthCategory = Category(id: 6, category: "Health", icon: Image("health"), imageName: "heart.circle")
var workCategory = Category(id: 7, category: "Work", icon: Image("work"), imageName: "dollarsign.circle.fill")
var taxCategory = Category(id: 8, category: "Tax", icon: Image("tax"), imageName: "dollarsign.square.fill")
var insuranceCategory = Category(id: 9, category: "Insurance", icon: Image("insurance"), imageName: "cloud.rain.fill")
var educationCategory = Category(id: 10, category: "Education", icon: Image("education"), imageName: "book.circle")

// Filler Category
var othersCategory = Category(id: 11, category: "Others", icon: Image("questionmark"), imageName: "questionmark.folder")





