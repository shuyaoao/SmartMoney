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
        .frame(height: 350)
    }
}

struct TransactionScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScrollView()
    }
}
