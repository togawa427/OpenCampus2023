//
//  ChartDual.swift
//  OpenCampusLocation2023
//
//  Created by 戸川浩汰 on 2023/07/08.
//

import SwiftUI
import Charts

struct ChartDualView: View {
    var yWheel: [Int]
    var yPerson: [Int]
    var intervalSec: Double
    
    @State var plotRange = 30   // 範囲を変えたいときはここと
    
    
    var body: some View {
        VStack{
            Chart {
                ForEach(yWheel.indices, id: \.self) { index in
                    // 折れ線グラフをプロット
                    let xValue = Double(index) * intervalSec
                    let yValue = yWheel[index]
                    
                    LineMark(
                        x: .value("x", xValue),
                        y: .value("y", yValue)
                    )
                    .foregroundStyle(by: .value("Category", "タイヤ"))
                }
                ForEach(yPerson.indices, id: \.self) { index in
                    // 折れ線グラフをプロット
                    let xValue = Double(index) * intervalSec
                    let yValue = yPerson[index]
                    
                    LineMark(
                        x: .value("x", xValue),
                        y: .value("y", yValue)
                    )
                    .foregroundStyle(by: .value("Category", "介護者"))
                }
            }
            .chartXScale(domain: (Double(yWheel.count) * intervalSec) - Double(plotRange) ... Double(yWheel.count) * intervalSec)
            .chartYScale(domain: -100 ... 0)
            .chartForegroundStyleScale(["タイヤ": .pink, "介護者": .green])
        }
    }
}

