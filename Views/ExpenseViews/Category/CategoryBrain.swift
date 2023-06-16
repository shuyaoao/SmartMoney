//
//  CategoryData.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import Foundation
import UIKit
import SwiftUI

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
    var first : Category
    var second: Category
    var third : Category
}

class CategoryDataModel : ObservableObject {
    @Published var listofCategories : [Category]
    
    init(listofCategories: [Category]) {
        self.listofCategories = listofCategories
    }
}

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

var catDataSource = CategoryDataModel(listofCategories: [foodCategory, transportCategory, groceriesCategory, entertainmentCategory, utilitiesCategory, clothingCategory, healthCategory, workCategory, taxCategory, insuranceCategory, educationCategory])

// MARK: Category Data Source
// Filler Category
var unfilledCategory = Category(id: 11, category: "", icon: Image("questionmark"))


// Constructing the Stacks of Categories for UI Purposes
/*
var listCatStack = [CategoryStack(id: 0 ,
                                  first: catDataSource.listofCategories[0],
                                  second: catDataSource.listofCategories[1],
                                  third: catDataSource.listofCategories[2]),
                    CategoryStack(id: 1 , first: catDataSource.listofCategories[3],
                                  second: catDataSource.listofCategories[4],
                                  third: catDataSource.listofCategories[5])
 */
                    




