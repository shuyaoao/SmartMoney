//
//  categoryHorizontalScrollView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import SwiftUI

struct CategoryHorizontalScrollView: View {
    @ObservedObject var CategoryDataSource : CategoryDataModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(0..<CategoryDataSource.listofCategories.count - 2, id: \.self) { index in
                        if index % 3 == 0 {
                            categoryStackView(first: CategoryDataSource.listofCategories[index],
                                              second: CategoryDataSource.listofCategories[index + 1],
                                              third: CategoryDataSource.listofCategories[index + 2])
                        }
                    }
                }
            }
            .frame(height: 150)
        }
        
    }
}

struct categoryHorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHorizontalScrollView(CategoryDataSource : catDataSource)
    }
}
