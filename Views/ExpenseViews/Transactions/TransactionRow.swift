//
//  TransactionRow.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import SwiftUI

struct TransactionRow: View {
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                // MARK: Transaction Name
                Text(transaction.name)
                    .font(Font.subheadline)
                    .bold()
                    .lineLimit(1)
                
                // MARK: Transaction Category
                
                HStack(spacing: 8) {
                    // Adding Category Icon
                    transaction.category.icon
                    
                    // Category Text
                    Text(transaction.category.category)
                        .font(.footnote)
                        .opacity(0.7)
                        .lineLimit(1)
                        
                }
                
                
                // MARK: Transaction Date
                Text(transaction.date)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // MARK: Transaction Amount
            if transaction.isExpense == true {
                Text(String(format: "-$%.2f", transaction.amount))
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
            // If Income
            } else {
                Text(String(format: "+$%.2f", transaction.amount))
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }

        }
        .padding([.all], 14)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    Color(red: 175/255, green: 211/255, blue: 226/255)))
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: transactionPreviewDataList[0])
    }
}
