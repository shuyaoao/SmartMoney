//
//  categoryStackView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import SwiftUI

struct categoryStackView: View {
    var first : Category
    var second : Category
    var third : Category
    
    var body: some View {
        VStack(spacing: 10) {
            categoryDataCellView(category: first)
            categoryDataCellView(category: second)
            categoryDataCellView(category: third)
        }
    }
}

struct categoryStackView_Previews: PreviewProvider {
    static var previews: some View {
        categoryStackView(first: catDataSource.listofCategories[0],
                          second: catDataSource.listofCategories[1],
                          third: catDataSource.listofCategories[2])
    }
}
