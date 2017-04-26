//
//  StartViewController.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 11.04.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import UIKit
import RealmSwift
import Charts
class StartViewController: UIViewController{

    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var pieChartBalance: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
         balanceLabel.text = countTheBalance()
         updatePieChartWithData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
            
    func countTheBalance() -> String {
        var balance = 0
        let realmMoney = try! Realm()
        let allPlusMoney = realmMoney.objects(PlusMoney.self)
        let allMinusMoney = realmMoney.objects(MinusMoney.self)
        for money in allPlusMoney {
            balance += money.amount
        }
        for money in allMinusMoney{
            balance -= money.amount
        }
        return String(balance)
    }
    
    func updatePieChartWithData(){
        var dataEntries: [PieChartDataEntry] = []
        
        let realmMoney = try! Realm()
        let allMinusMoney = realmMoney.objects(MinusMoney.self)
        
        var amountOfMoneyForCategory = 0
        var moneyDict = [String: Int]()
        //если существует ключ "категория", то прибавить к ней, иначк создать с 0 и пприбавить.
        for money in allMinusMoney {
            amountOfMoneyForCategory = money.amount
            for money2 in allMinusMoney{
                if (money.category == money2.category && money.id != money2.id){
                    amountOfMoneyForCategory += money2.amount
                }
            }
            moneyDict[money.category] = amountOfMoneyForCategory
            
            /*
            if (moneyDict[money.category] != nil)
                moneyDict[money.category] = 0
            moneyDict[money.category] += money.amount
            */
        }
        for (moneyCategory, moneyAmount) in moneyDict{
            let dataEntry = PieChartDataEntry(value: Double(moneyAmount), label:moneyCategory)
                dataEntries.append(dataEntry)
        }
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "Денег потрачено")
        chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartBalance.data = chartData
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
