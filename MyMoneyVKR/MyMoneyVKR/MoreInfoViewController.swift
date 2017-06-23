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
    let creation : NSDate!
    
}
let formatter = DateFormatter()

//Функция заполнения ячейки

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
        let newElem = cellData.init(name: money.name, amount: "+" + String(money.amount) + "руб", date: Date().theFormattedDate(date: money.createdAT), time: Date().theFormattedTime(time: money.createdAT), imageType: imageType, emojiImage: emojiImage, creation: money.createdAT)
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
            emojiImage = UIImage(named: "medicineImage")!
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
        
        let newElem = cellData.init(name: money.name, amount: "-" + String(money.amount) + "руб", date: Date().theFormattedDate (date: money.createdAT), time: Date().theFormattedTime(time: money.createdAT), imageType: imageType, emojiImage : emojiImage, creation: money.createdAT)
        arrayOfCells.append(newElem)
    }
    return arrayOfCells
}

    var array = [cellData]()
var filteredArray = [cellData?](repeating:nil, count: 30)
///////////////////////////////////////Extension for the date parametrs///////////////////////////////////////
extension Date {
    
    // formatted date
    func theFormattedDate(date: NSDate) -> String{
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "dd MMMM, EEEE"
        dateFormatterDate.locale = NSLocale(localeIdentifier: "RU") as Locale!
        return dateFormatterDate.string(from: date as Date)
    }
    
    func theFormattedDay(day: NSDate) -> String{
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "dd MMMM"
        dateFormatterDate.locale = NSLocale(localeIdentifier: "RU") as Locale!
        return dateFormatterDate.string(from: day as Date)
    }

    //formatted time
    func theFormattedTime(time: NSDate) -> String{
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm"
        dateFormatterTime.locale = NSLocale(localeIdentifier: "RU") as Locale!
        return dateFormatterTime.string(from: time as Date)
    }
    
    func theFormattedMonth(month: NSDate) -> String{
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "MMMM"
        dateFormatterTime.locale = NSLocale(localeIdentifier: "RU") as Locale!
        return dateFormatterTime.string(from: month as Date)
    }

    // startDate
    func startDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd" // "dd MMMM, EEEE" //"yyyy MM dd"
        formatter.locale = NSLocale(localeIdentifier: "RU") as Locale!
        
        let startDate = formatter.date(from: "2017 03 01")
        formatter.dateFormat = "dd MMMM, EEEE"
        //let startDate = Date()
        return startDate!
    }

}

///////////////////////////////////////The beginning of class///////////////////////////////////////

class MoreInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    let black = UIColor.black
    let white = UIColor.white
    let gray = UIColor.gray
    let blue = UIColor(red: 2.0/255.0, green: 164.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    
///////////////////////////////////////Outlets///////////////////////////////////////
   
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var historyTableView: UITableView!
    
///////////////////////////////////////Actions///////////////////////////////////////
   
    @IBAction func backButtonArrow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonText(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredArray.count > 14 {
            return 14
        }
        else {
            return filteredArray.count
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        filteredArray = filteredArray.sorted(by: {($0!.creation! as Date).compare($1!.creation! as Date) == .orderedDescending})
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreInfoTableViewCell
        if !filteredArray.isEmpty{
            if (filteredArray[indexPath.row]?.amount.characters.contains("+"))!
            {
                cell.amountLabel.textColor = UIColor(red: 129.0/255.0, green: 184/255.0, blue: 12/255.0, alpha: 1.0)
            } else {
                cell.amountLabel.textColor = UIColor(red: 234.0/255.0, green: 78.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            }
            cell.amountLabel.text = filteredArray[indexPath.row]?.amount
            cell.nameLabel.text = filteredArray[indexPath.row]?.name
            cell.dateAndDayLabel.text = filteredArray[indexPath.row]?.date
            cell.timeLabel.text = filteredArray[indexPath.row]?.time
            cell.cardOrCashImageView.image = filteredArray[indexPath.row]?.imageType
            cell.emojiImageView.image = filteredArray[indexPath.row]?.emojiImage
        } else {
            cell.amountLabel.text = array[indexPath.row].amount
            cell.nameLabel.text = array[indexPath.row].name
            cell.dateAndDayLabel.text = array[indexPath.row].date
            cell.timeLabel.text = array[indexPath.row].time
            cell.cardOrCashImageView.image = array[indexPath.row].imageType
            cell.emojiImageView.image = array[indexPath.row].emojiImage
        }
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.gray.cgColor
       
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }

///////////////////////////////////////Function of calendar cells colour///////////////////////////////////////
    
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let calendarCell = view as? CalendarCell else {
            return
        }
        
        if cellState.isSelected {
            calendarCell.dayLabel.textColor = white
             filteredArray = array.filter { $0.date == Date().theFormattedDate(date: cellState.date as NSDate)  }
            if filteredArray.isEmpty {
                filteredArray = array
            }
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                calendarCell.dayLabel.textColor = black
            } else {
                calendarCell.dayLabel.textColor = gray
            }
        }
        for _ in filteredArray {
            historyTableView.reloadData()
            historyTableView.isHidden = false
        }
    }
    
///////////////////////////////////////Function to handle the calendar selection///////////////////////////////////////
    
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

///////////////////////////////////////Configuration of the calendar///////////////////////////////////////
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date().startDate()
        let endDate = Date()
        let parameters = ConfigurationParameters(startDate: startDate,endDate: endDate,numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .monday)
        return parameters
    }
    
///////////////////////////////////////Function of displaying the calendarView///////////////////////////////////////
    
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
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.register(UINib(nibName: "MoreInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCell") // Registering cell is manditory
        calendarView.visibleDates { visibleDates in self.setupViewsOfCalendar(from: visibleDates)}
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!
        formatter.locale = NSLocale(localeIdentifier: "RU") as Locale!
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        calendarView.scrollToDate(Date())
        array = fillTheCellData()
        filteredArray = array
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//        array = fillTheCellData()
//        filteredArray = array
//    }
    
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
