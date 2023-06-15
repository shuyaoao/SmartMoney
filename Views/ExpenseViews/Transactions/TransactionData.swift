//
//  TransactionPreviewData.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id: 0,
                                         name: "Apple",
                                         date: "01/24/2023",
                                         category: utilitiesCategory,
                                         amount: 30.00,
                                         isExpense: true)

var transactionPreviewDataList = [Transaction](repeating: transactionPreviewData, count: 10)

