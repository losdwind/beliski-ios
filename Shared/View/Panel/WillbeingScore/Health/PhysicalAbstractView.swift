//
//  HealthAbstractView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

struct PhysicalAbstractView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // MARK: Number of Steps
                    BarChartView(data: TestData.values ,
                                 title: "Steps",
                                 legend: "Weekly",
                                 valueSpecifier: "%.0f")
                        .padding()
                    
                    // MARK: Number of Acitivities
                    BarChartView(data: TestData.values ,
                                 title: "No. Activities",
                                 legend: "Weekly",
                                 style: Styles.barChartStyleNeonBlueLight,
                                 valueSpecifier: "%.0f")
                        .padding()
                    
                    
                    // MARK: Number of Non-identical Destinations
                    
                    BarChartView(data: TestData.values ,
                                 title: "No. Destinations",
                                 legend: "Weekly",
                                 style: Styles.barChartMidnightGreenLight,
                                 valueSpecifier: "%.0f")
                        .padding()
                }
                
                
            }
        }
    }
}

struct PhysicalAbstractView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicalAbstractView()
    }
}
