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
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: 15
                )
            Circle()
                // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            Text(String(format: "%.0f%%", progress * 100))
            
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.7)
            .frame(width: 100, height: 100)
    }
}
