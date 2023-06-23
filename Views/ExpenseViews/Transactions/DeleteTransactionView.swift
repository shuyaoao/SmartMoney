//
//  DeleteTransactionView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 23/6/23.
//

import SwiftUI

struct DeleteTransactionView: View {
    @ObservedObject var transactiondatamodel : TransactionDataModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(transactiondatamodel.filteredTransactionDataList) { transaction in
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
                                ZStack {
                                    Circle()
                                        .foregroundColor(.teal)
                                        .frame(width: 20, height: 20)
                                    transaction.category.icon
                                }
                                
                                
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
                        // If Income
                        } else {
                            Text(String(format: "+$%.2f", transaction.amount))
                                .foregroundColor(.green)
                        }

                    }
                    .padding([.all], 5)
                }
                .onDelete(perform: delete)
            }
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
            .navigationTitle("Transactions")
        }
    }
    
    func delete(at offsets: IndexSet) {
        // Construct an array of the Index
        let indexesToRemove = Array(offsets)
        
        // Retrieve the id of the Transaction that is to be removed
        let idsToRemove = indexesToRemove.map { transactiondatamodel.filteredTransactionDataList[$0].id
        }
        
        // Remove the id from the TransactionDataModel
        for id in idsToRemove {
            transactiondatamodel.removeTransaction(id: id)
        }
        
        // Reset the id of all transactions (for future update/delete)
        transactiondatamodel.resetTransactionIndexes()
        
       
    }
    
    
}

struct DeleteTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteTransactionView(transactiondatamodel: transactionDataModel)
    }
}
