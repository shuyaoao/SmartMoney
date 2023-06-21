//
//  TransactionScrollView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import SwiftUI

struct TransactionScrollView: View {
    @ObservedObject var transactionDataModel : TransactionDataModel
    @State var pickedYear : Int
    @State var pickedMonth : Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // For each transaction in the transaction data model
                // Filter the transaction data according to the Picked Date in the Interface
                ForEach(transactionDataModel.filteredTransactionDataList) { trans in
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
        TransactionScrollView(transactionDataModel : transactionDataModel,
                              pickedYear: dateModel.pickedYear,
                              pickedMonth: dateModel.pickedMonth)
    }
}
