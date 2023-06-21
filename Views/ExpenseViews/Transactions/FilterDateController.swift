//
//  FilterDateController.swift
//  SmartMoney
//
//  Created by Dylan Lo on 21/6/23.
//

import Foundation


class DateModel: ObservableObject {
    @Published var pickedYear : Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var pickedMonth : Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    init(pickedYear : Int, pickedMonth : Int) {
        self.pickedYear = pickedYear
        self.pickedMonth = pickedMonth
    }
    
    func changeYearandMonth(year : Int, month : Int) {
        self.pickedYear = year
        self.pickedMonth = month
    }
}


let currentDate = Date()
let calendar = Calendar.current
let thisYear = calendar.component(.year, from: currentDate)
let thisMonth = calendar.component(.month, from: currentDate)


let dateModel = DateModel(pickedYear: thisYear, pickedMonth: thisMonth)
    

    
    
    
