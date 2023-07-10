//
//  ChartView.swift
//  OpenCampusLocation2023
//
//  Created by 戸川浩汰 on 2023/07/08.
//

import SwiftUI
import Charts

struct PointsData: Identifiable {
    // 点群データの構造体
    
    var xValue: Double
    var yValue: Int
    var id = UUID()
}

struct ChartView: View {
    var y: [Int]
    var intervalSec: Double
    var countScanning: Int
    
    
    // sampleデータを定義
    //    @State var data: [PointsData] = [
    //        .init(xValue: 0, yValue: 5),
    //        .init(xValue: 1, yValue: 4)
    //    ]
    //
    @State var plotRange = 30   // 範囲を変えたいときはここと
    
    
    var body: some View {
        VStack{
            Chart {
                ForEach(y.indices, id: \.self) { index in
                    // 折れ線グラフをプロット
                    let xValue = Double(index) * intervalSec
                    let yValue = y[index]
                    
                    LineMark(
                        x: .value("x", xValue),
                        y: .value("y", yValue)
                    )
                }
            }
            .chartXScale(domain: (Double(y.count) * intervalSec) - Double(plotRange) ... Double(y.count) * intervalSec)
            .chartYScale(domain: -100 ... 0)
            .chartXAxis{
                AxisMarks(values: .automatic(desiredCount: 3)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                }
            }
        }
    }
}

//struct ChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartView(y: [5, 4])
//    }
//}

