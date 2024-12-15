//
//  ViewController.swift
//  ChartDemo
//
//  Created by Mahesh Giri on 14/12/24.
//

import UIKit
import Foundation
import AAInfographics

class ViewController: UIViewController, AAChartViewDelegate  {
    @IBOutlet weak var vwAreaSplineChart: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    private var aaChartView: AAChartView?
    private var data = [HeartRate]()
    private var dateCount = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        readJSONFile(forName: "response")
        
        let chartViewWidth  = self.vwAreaSplineChart.frame.size.width
        let chartViewHeight = self.vwAreaSplineChart.frame.size.height
        aaChartView = AAChartView()
        aaChartView?.frame = CGRect(x: 0,
                                    y: 0,
                                    width: chartViewWidth,
                                    height: chartViewHeight)
        aaChartView?.delegate = self
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.vwAreaSplineChart.addSubview(aaChartView!)
        
        let aaChartModel = AAChartModel()
            .chartType(.areaspline)
            .yAxisGridLineWidth(0)
            .xAxisGridLineWidth(0)
            .categories(self.data.map({convertDateFormat(date: $0.date ?? "")}))
            .dataLabelsEnabled(false)
            .markerRadius(8)
            .markerSymbol(.circle)
            .markerSymbolStyle(.innerBlank)
            .legendEnabled(true)
            .title("Heart Rate")
            .tooltipEnabled(true)
            .tooltipValueSuffix("bpm")
            .series([
                AASeriesElement()
                    //.threshold((-200))
                    .name("Heart Rate")
                    .data(self.data.map({$0.heartRate ?? 0}))
                    .lineWidth(2)
                    .allowPointSelect(true)
                    .color(AARgba(210, 10, 46,1))
                    .fillColor(AAGradientColor.linearGradient(
                        direction: .toBottom,
                        startColor: AARgba(210, 10, 46, 1),
                        endColor: AARgba(210, 10, 46, 0.1)
                    ))
            ])
        
        
        //The chart view object calls the instance object of AAChartModel and draws the final graphic
        aaChartView?.aa_drawChartWithChartModel(aaChartModel)
        
    }
    
    func callAPI() {
        URLSession.shared.dataTask(with: URL(string: "http://192.168.1.106:8000/api/dates")!) { data, response, error in
            guard let data else { return }
            do {
                let json = try JSONDecoder().decode(HeartRateDetails.self, from: data)
                print(json)
            } catch {
                print(error)
            }
        }
    }
    
    func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
            print(
                """

                moved over point series element name: \(moveOverEventMessage.name ?? "")
                ✋🏻✋🏻✋🏻✋🏻✋🏻WARNING!!!!!!!!!!!!!! Move Over Event Message !!!!!!!!!!!!!! WARNING✋🏻✋🏻✋🏻✋🏻✋🏻
                ==========================================================================================
                ------------------------------------------------------------------------------------------
                user finger moved over!!!,get the move over event message: {
                category = \(String(describing: moveOverEventMessage.category))
                index = \(String(describing: moveOverEventMessage.index))
                name = \(String(describing: moveOverEventMessage.name))
                offset = \(String(describing: moveOverEventMessage.offset))
                x = \(String(describing: moveOverEventMessage.x))
                y = \(String(describing: moveOverEventMessage.y))
                }
                +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                
                
                """
            )
        }
    
        func aaChartView(_ aaChartView: AAChartView, clickEventMessage: AAClickEventMessageModel) {
            print(
                """

                clicked point series element name: \(clickEventMessage.name ?? "")
                🖱🖱🖱WARNING!!!!!!!!!!!!!!!!!!!! Click Event Message !!!!!!!!!!!!!!!!!!!! WARNING🖱🖱🖱
                ==========================================================================================
                ------------------------------------------------------------------------------------------
                user finger moved over!!!,get the move over event message: {
                category = \(String(describing: clickEventMessage.category))
                index = \(String(describing: clickEventMessage.index))
                name = \(String(describing: clickEventMessage.name))
                offset = \(String(describing: clickEventMessage.offset))
                x = \(String(describing: clickEventMessage.x))
                y = \(String(describing: clickEventMessage.y))
                }
                +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                
                
                """
            )
        }
    
    @IBAction func columnChartButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RangeColumnChartVC") as! RangeColumnChartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
       
        if dateCount > 0 {
            lblDate.text = data[dateCount - 1].date
            dateCount -= 1
        }
        aaChartView?.aa_redraw()
        
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        if dateCount < data.count {
            lblDate.text = data[dateCount].date
            dateCount += 1
        }
       // aaChartView?.delegate = self
    }
    
    func convertDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d M"
        
        if let date = dateFormatter.date(from: date) {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func readJSONFile(forName name: String) {
       do {
       
          // creating a path from the main bundle and getting data object from the path
          if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
             let jsonData = try String(contentsOfFile: bundlePath, encoding: .utf8).data(using: .utf8) {
                
             // Decoding the Product type from JSON data using JSONDecoder() class.
              let product = try JSONDecoder().decode(HeartRateDetails.self, from: jsonData)
              data = product.data ?? []
              dateCount  = data.count
              print("Product name: \(product.message ?? "")")
          }
       } catch {
          print(error)
       }
    }
}

struct HeartRateDetails: Codable {
    
    var status  : String? = nil
    var message : String? = nil
    var data    : [HeartRate]? = []
    
    enum CodingKeys: String, CodingKey {
        
        case status  = "status"
        case message = "message"
        case data    = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status  = try values.decodeIfPresent(String.self , forKey: .status  )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        data    = try values.decodeIfPresent([HeartRate].self , forKey: .data    )
        
    }
    
    init() {
        
    }
    
}

struct HeartRate: Codable {
    
    var id        : Int?    = nil
    var date      : String? = nil
    var heartRate : Int?    = nil
    
    enum CodingKeys: String, CodingKey {
        
        case id        = "id"
        case date      = "date"
        case heartRate = "heart_rate"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id        = try values.decodeIfPresent(Int.self    , forKey: .id        )
        date      = try values.decodeIfPresent(String.self , forKey: .date      )
        heartRate = try values.decodeIfPresent(Int.self    , forKey: .heartRate )
        
    }
    
    init() {
        
    }
    
}
