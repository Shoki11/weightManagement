//
//  ChartViewController.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import UIKit
import Charts
import FirebaseAuth

class ChartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ChartViewDelegate, GetDataProtocol {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var chartView: LineChartView!
   
    var send = sendToFireBase()
    var load = Load()
    var chartArray = [PersonalData]()
    
    // チャートデータ
    var lineDataSet: LineChartDataSet!
    
    let years = (2021...2031).map{$0}
    let months = (1...12).map{$0}

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        chartView.backgroundColor = .white
        
        // 透明度
        chartView.alpha = 0.8
        
        load.getDataProtocol = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 現在時刻で年月を取得後、その月のデータを全て取得
        let date = GetDate.getTodayDate(slash: true)
        
        // 2001/01/23を/で区切る
        let dateArray = date.components(separatedBy: "/")
        
        load.loadMyRecordData(userID: Auth.auth().currentUser!.uid, yearMonth: dateArray[0] + dateArray[1], day: dateArray[2])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return years.count
            
        } else if component == 1 {
            
            return months.count
            
        } else {
            
            return 0
            
        }
        
    }
    
    // pickerViewのたて2行
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
        
    }
    
    // pickerViewのタイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return "\(years[row])年"
            
        } else if component == 1 {
            
            return "\(months[row])月"
            
        } else {
            
            return nil
            
        }
        
    }
    
    // pickerが選択された時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let year = years[pickerView.selectedRow(inComponent: 0)]
        let month = months[pickerView.selectedRow(inComponent: 1)]
        
        var month2 = String()
        
        if month < 10 {
            
            month2 = "0" + String(month)
            
            
            load.loadMyRecordData(userID: Auth.auth().currentUser!.uid, yearMonth: String(year) + month2, day: "")
            
        } else {
            
            //selectMonth.text = " \(year)年\(month)月"
            load.loadMyRecordData(userID: Auth.auth().currentUser!.uid, yearMonth: String(year) + String(month), day: "")
            
        }
        
    }
    
    func getData(dataArray: [PersonalData]) {
        
        chartArray = dataArray
        
        // チャートへの反映
        setUpChart(values: chartArray)
        
        // 自分の差分
        if chartArray.count > 0 {
            
            result.text = "\(String(floor((Double(chartArray.last!.weight)! - Double(chartArray.first!.weight)!) * 10) / 10))kg"
            
            // xの値の表示を上に
            chartView.xAxis.labelPosition = .top
            
            // xの線をchartArrayの数だけ表示
            chartView.xAxis.labelCount = chartArray.count

            send.sendResultWeightToDB(userName: GetUserData.getUserData(key: "userName"), weight: result.text!)
            
        }
        
    }
    
    // 値をチャート反映のためのメソッド
    func setUpChart(values: [PersonalData]) {
        
        let formatter : DateFormatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ja_JP")
        
        formatter.dateStyle = .short
        
        var entry = [ChartDataEntry]()
        
        for i in 0 ..< values.count {
            
            let date = Date(timeIntervalSince1970: values[i].date)
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "ja_JP")
            
            dateFormatter.dateFormat = "dd"
            
            let dateString = dateFormatter.string(from: date)
            
            // x軸が日付, y軸が体重
            entry.append(ChartDataEntry(x: Double(dateString)!, y: Double(values[i].weight)!))
            
        }
        
        let dataSet = LineChartDataSet(entries: entry, label: "私の体重")
        
        chartView.data = LineChartData(dataSet: dataSet)
        
    }
    
    // チャートの基本設定
    func setUpLineChart(_ chart: LineChartView, data: LineChartData) {
        
        chart.delegate = self
        
        // チャートの項目の表示を行うか
        chart.chartDescription?.enabled = true
        
        // チャートのドラッグの操作
        chart.dragEnabled = true
        
        // チャートの拡大表示
        chart.setScaleEnabled(true)
        
        // メモリの表示
        chart.setViewPortOffsets(left: 30, top: 0, right: 0, bottom: 30)
        
        // 凡例を表示
        chart.legend.enabled = true
        
        // チャートの左のメモリ
        chart.leftAxis.enabled = true
        chart.leftAxis.spaceTop = 0.4
        chart.leftAxis.spaceBottom = 0.4
        
        // 右のメモリ
        chart.leftAxis.enabled = false
        
        // メモリの線
        chart.xAxis.enabled = true
        
        
        chart.data = data
        
        // チャートの描画アニメーション(2time)
        chart.animate(xAxisDuration: 10)
        
        // グラフの色
        chart.backgroundColor = .green
        
    }
}
