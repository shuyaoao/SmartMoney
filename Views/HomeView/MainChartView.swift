//
//  MainChartView.swift
//  SmartMoney
//
//  Created by Dylan Lo on 13/7/23.
//

import SwiftUI
import SwiftUICharts

struct MainChartView: View {
    @ObservedObject var model = TransactionDataModel(transactionDataList: transactionPreviewDataList)
    
    var body: some View {
        BarChartView(data: ChartData(values: model.getPastSixMonthsExpenses()),
                    title: "Expenses Overview",
                    legend: "Month", style: Styles.barChartStyleNeonBlueLight,
                    form: ChartForm.extraLarge,
                    valueSpecifier: "%.0f"
        ).onAppear {
           
        }
    }
}

struct MainChartView_Previews: PreviewProvider {
    static var previews: some View {
        MainChartView()
    }
}
