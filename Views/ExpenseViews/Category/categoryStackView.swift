//
//  categoryStackView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import SwiftUI

struct categoryStackView: View {
    var catStack : CategoryStack
    
    var body: some View {
        VStack(spacing: 6) {
            categoryDataCellView(category: catStack.stack[0])
            categoryDataCellView(category: catStack.stack[1])
            categoryDataCellView(category: catStack.stack[2])
            
        }
    }
}

struct categoryStackView_Previews: PreviewProvider {
    static var previews: some View {
        categoryStackView(catStack: listCatStack[0])
    }
}
