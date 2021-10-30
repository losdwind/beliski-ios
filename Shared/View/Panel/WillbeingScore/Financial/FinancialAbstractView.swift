//
//  FinancialAbstractView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

struct FinancialAbstractView: View {
    var body: some View {
            LineGraph(data: [
                989,1200,750,790,650,950,1200,600,500,600,890,1203,1400,900,1250,1600,1200])
                .frame(height: 220)
                .padding(.top,25)
        
    }
}

struct FinancialAbstractView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialAbstractView()
    }
}
