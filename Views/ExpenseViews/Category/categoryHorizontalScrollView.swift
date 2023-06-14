//
//  categoryHorizontalScrollView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import SwiftUI

struct categoryHorizontalScrollView: View {
    let listCatStack : [CategoryStack]
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(listCatStack) { catStack in
                    categoryStackView(catStack: catStack)
                }
            }
        }
        .frame(height: 400)
    }
}

struct categoryHorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        categoryHorizontalScrollView(listCatStack: listCatStack)
    }
}
