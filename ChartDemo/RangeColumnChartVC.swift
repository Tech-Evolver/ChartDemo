//
//  RangeColumnChartVC.swift
//  ChartDemo
//
//  Created by Mahesh Giri on 15/12/24.
//

import UIKit
import AAInfographics

class RangeColumnChartVC: UIViewController {
    
    @IBOutlet weak var vwRangeColumnChart: UIView!

    private var aaChartView: AAChartView?
    override func viewDidLoad() {
        super.viewDidLoad()

        let chartViewWidth  = self.vwRangeColumnChart.frame.size.width
        let chartViewHeight = self.vwRangeColumnChart.frame.size.height
        aaChartView = AAChartView()
        aaChartView?.frame = CGRect(x: 0,
                                    y: 0,
                                    width: chartViewWidth,
                                    height: chartViewHeight)
       // aaChartView?.delegate = self
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.vwRangeColumnChart.addSubview(aaChartView!)
       
        let aaChartModel = AAChartModel()
            .colorsTheme(["#1e90ff", "#EA007B", "#49C1B6", "#FDC20A", "#F78320", "#068E81",])//主题颜色数组
            .chartType(.line)
            .dataLabelsEnabled(true)
            .markerSymbolStyle(.borderBlank)
            .zoomType(.xy)
            .series([
                AASeriesElement()
                    .name("Temperature")
                    .type(.columnrange)
                    .data([
                        [(-9.7),  9.4],
                        [(-8.7),  6.5],
                        [(-3.5),  9.4],
                        [(-1.4), 19.9],
                        [0.0 ,   22.6],
                        [2.9 ,   29.5],
                        [9.2 ,   30.7],
                        [7.3 ,   26.5],
                        [4.4 ,   18.0],
                        [(-3.1), 11.4],
                        [(-5.2), 10.4],
                        [(-9.9), 16.8]
                    ])
                    .color(AARgba(210, 10, 46,1))
                    .fillColor(AAGradientColor.linearGradient(
                        direction: .toBottom,
                        startColor: AARgba(210, 10, 46, 1),
                        endColor: AARgba(210, 10, 46, 0.1)
                    ))
            ])
        aaChartView?.aa_drawChartWithChartModel(aaChartModel)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
