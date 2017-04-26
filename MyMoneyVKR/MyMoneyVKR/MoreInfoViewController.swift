//
//  MoreInfoViewController.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 13.04.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import UIKit
import RealmSwift
import JTAppleCalendar

struct cellData {
    let name : String!
    let amount : String!
    let date : String!
    let time : String!
    let imageType : UIImage!
    let emojiImage : UIImage!
}

func fillTheCellData() -> [cellData]{
    let realmMoney = try! Realm()
    let allPlusMoney = realmMoney.objects(PlusMoney.self)
    let allMinusMoney = realmMoney.objects(MinusMoney.self)
    var imageType : UIImage!
    
    var arrayOfCells = [cellData]()
    
    var emojiImage = UIImage()
    for money in allPlusMoney {
        if (money.type == "Карта"){
            imageType = UIImage(named:"cardPlus")
        } else {
            imageType = UIImage(named:"cashPlus")
        }
        
        switch money.category {
        case "Зарплата" :
            emojiImage = UIImage(named: "salaryImage")!
        case "Бизнес" :
            emojiImage = UIImage(named: "businessImage")!
        case "Долги" :
            emojiImage = UIImage(named: "debtsImage")!
        case "Подарок" :
            emojiImage = UIImage(named: "presentImage")!
        case "Проценты" :
            emojiImage = UIImage(named: "bankAccountImage")!
        case "Сбережения" :
            emojiImage = UIImage(named: "savingsImage")!
        default:
            break
            
        }
        let newElem = cellData.init(name: money.name, amount: "+" + String(money.amount) + "руб", date: Date().theFormattedDate(date: money.createdAT), time: Date().theFormattedTime(time: money.createdAT), imageType: imageType, emojiImage: emojiImage)
        arrayOfCells.append(newElem)
    }
    for money in allMinusMoney {
        if (money.type == "Карта"){
            imageType = UIImage(named:"cardMinus")
        } else {
            imageType = UIImage(named:"cashMinus")
        }
        
        switch money.category {
        case "Машина" :
            emojiImage = UIImage(named: "carImage")!
        case "Одежда" :
            emojiImage = UIImage(named: "clothesImage")!
        case "Еда" :
            emojiImage = UIImage(named: "foodImage")!
        case "Развлечения" :
            emojiImage = UIImage(named: "entertainmentImage")!
        case "Счета" :
            emojiImage = UIImage(named: "houseBillsImage")!
        case "Гигиена" :
            emojiImage = UIImage(named: "hygieneImage")!
        case "Медицина" :
            emojiImage = UIImage(named: "madicineImage")!
        case "Животные" :
            emojiImage = UIImage(named: "petsImage")!
        case "Магазины" :
            emojiImage = UIImage(named: "shopsImage")!
        case "Такси" :
            emojiImage = UIImage(named: "taxiImage")!
        case "Транспорт" :
            emojiImage = UIImage(named: "transportImage")!
        case "Спорт" :
            emojiImage = UIImage(named: "sportsImage")!
        default:
            break
        }
        
        let newElem = cellData.init(name: money.name, amount: "-" + String(money.amount) + "руб", date: Date().theFormattedDate (date: money.createdAT), time: Date().theFormattedTime(time: money.createdAT), imageType: imageType, emojiImage : emojiImage)
        arrayOfCells.append(newElem)
    }
    return arrayOfCells
}

    let array = fillTheCellData()
    var filteredArray = fillTheCellData()
    //filteredArray = filteredArray.sorted() {$0.time > $1.time}
extension Date {
    
    // formatted date
    func theFormattedDate(date: NSDate) -> String{
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "dd MMMM, EEEE"
        dateFormatterDate.locale = NSLocale(localeIdentifier: "RU") as Locale!
        return dateFormatterDate.string(from: date as Date)
    }
    
    //formatted time
    func theFormattedTime(time: NSDate) -> String{
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm"
        dateFormatterTime.locale = NSLocale(localeIdentifier: "RU") as Locale!
        return dateFormatterTime.string(from: time as Date)
    }
    
    func startDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, EEEE" //"yyyy MM dd"
        formatter.locale = NSLocale(localeIdentifier: "RU") as Locale!
        return formatter.date(from: "01 марта, среда")!
    }

}
class MoreInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    let black = UIColor.black
    let white = UIColor.white
    let gray = UIColor.gray
    let blue = UIColor(red: 2.0/255.0, green: 164.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    
    
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var historyTableView: UITableView!
    
    
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let calendarCell = view as? CalendarCell else {
            return
        }
        
        if cellState.isSelected {
            calendarCell.dayLabel.textColor = white
             filteredArray = array.filter { $0.date == Date().theFormattedDate(date: cellState.date as NSDate)  }
            if filteredArray.isEmpty {
                historyTableView.isHidden = true
            }
            for _ in filteredArray {
                    historyTableView.reloadData()
                    historyTableView.isHidden = false
            }
        } else {
            
            if cellState.dateBelongsTo == .thisMonth {
                calendarCell.dayLabel.textColor = black
            } else {
                calendarCell.dayLabel.textColor = gray
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let calendarCell = view as? CalendarCell  else {
            return
        }
        if cellState.isSelected {
            calendarCell.selectedBackgroundView.isHidden = false
        } else {
            calendarCell.selectedBackgroundView.isHidden = true
        }
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let startDate = Date().startDate()
        let endDate = Date()
        let parameters = ConfigurationParameters(startDate: startDate,endDate: endDate,numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .monday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CalendarCell
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.register(UINib(nibName: "MoreInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCell") // Registering cell is manditory
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        filteredArray = filteredArray.sorted() {$0.time > $1.time}
        filteredArray = filteredArray.sorted() {$0.date > $1.date}
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreInfoTableViewCell
        if (filteredArray[indexPath.row].amount.characters.contains("+")){
            cell.amountLabel.textColor = UIColor.init(red: 129.0/255.0, green: 184/255.0, blue: 12/255.0, alpha: 1.0)
        } else {
             cell.amountLabel.textColor = UIColor(red: 234.0/255.0, green: 78.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        }
        cell.amountLabel.text = filteredArray[indexPath.row].amount
        cell.nameLabel.text = filteredArray[indexPath.row].name
        cell.dateAndDayLabel.text = filteredArray[indexPath.row].date
        cell.timeLabel.text = filteredArray[indexPath.row].time
        cell.cardOrCashImageView.image = filteredArray[indexPath.row].imageType
        cell.emojiImageView.image = filteredArray[indexPath.row].emojiImage
        
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
