//
//  TransactionScrollView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import SwiftUI

struct TransactionScrollView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(transactionPreviewDataList) { trans in
                    TransactionRow(transaction: trans)
                }
            }
        }
        .frame(height: 405)
        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
    }
}

struct TransactionScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScrollView()
    }
}