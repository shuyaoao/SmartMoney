//
//  CircularProgressView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 1/6/23.
//

import SwiftUI
import UIKit

struct CircularProgressView: View {
    // 1
    @ObservedObject var budgetProgress: BudgetProgress
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                // 2
                .trim(from: 0, to: budgetProgress.progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: budgetProgress.progress)
            
            Text(String(format: "%.0f%%", budgetProgress.progress * 100))
                .font(Font.system(size: 12))
            
        }
        
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(budgetProgress: budgetProgressModel)
            .frame(width: 50, height: 50)
    }
}
