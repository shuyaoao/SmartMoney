//
//  categoryDataCellView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 14/6/23.
//

import SwiftUI

struct categoryDataCellView: View {
    @State var category : Category
    
    var body: some View {
        Button(action: {
            if category.selected == true {
                category.buttonunSelected()
            } else {
                category.buttonSelected()
            }
            
        }) {
            ZStack() {
                RoundedRectangle(cornerRadius: 15)
                    .fill(category.selectedColor)
                    .frame(width: 150, height: 35)
                
                HStack(spacing: 5) {
                    category.icon
                        .resizable()
                        .frame(width: 15, height: 15)
                        .offset(x : -5)
                    
                    Text(category.category)
                        .foregroundColor(.white)
                        .font(.system(size : 20))
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                }
            }
            
        }
        
    }
}

struct categoryDataCellView_Previews: PreviewProvider {
    static var previews: some View {
        categoryDataCellView(category: insuranceCategory)
    }
}
