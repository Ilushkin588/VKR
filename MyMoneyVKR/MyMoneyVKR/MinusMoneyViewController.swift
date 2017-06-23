//
//  MinusMoneyViewController.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 30.03.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import UIKit
import RealmSwift
import TextFieldEffects

class MinusMoneyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let realmMinusMoney = try!Realm()
    
    var typeMinusMoney = ""
    var categoryMinusMoney = ""
    
    @IBOutlet weak var nameOfMinusMoney: UITextField!
    @IBOutlet weak var amountOfMinusMoney: UITextField!
    
    @IBOutlet weak var typeMinusMoneySegmentControl: UISegmentedControl!
    
    
    let minusMoneyCellReuseIdentifier = "cell"
    
    let itemsMinusMoney = ["Машина", "Одежда", "Еда", "Развлечения", "Счета", "Гигиена", "Медицина", "Животные", "Магазины", "Такси", "Транспорт", "Спорт"]
    let minusMoneyImageArray = [UIImage(named:"car"), UIImage(named:"clothes"), UIImage(named:"food"), UIImage(named:"entertainment"), UIImage(named:"homebills"), UIImage(named:"hygiene"), UIImage(named:"medicine"), UIImage(named:"pets"), UIImage(named:"shop"), UIImage(named:"taxi"), UIImage(named:"transport"), UIImage(named:"sports")]
    
    //Выбор типа дохода
    @IBAction func typeMinusMoneySegmentControl(_ sender: Any) {
        if typeMinusMoneySegmentControl.selectedSegmentIndex == 0 {
            typeMinusMoney = "Наличные"
        }
        else {
            typeMinusMoney = "Карта"
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        typeMinusMoneySegmentControl.selectedSegmentIndex = 0
        typeMinusMoneySegmentControl((Any).self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.minusMoneyImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: minusMoneyCellReuseIdentifier, for: indexPath) as! MinusCollectionViewCell
        cell.minusImageCategory?.image = self.minusMoneyImageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryMinusMoney = self.itemsMinusMoney[indexPath.row]
    }
    
    
    @IBAction func addMinusMoneyButton(_ sender: Any) {
        
        if (nameOfMinusMoney.text! != "" && amountOfMinusMoney.text! != "" && categoryMinusMoney != "" && typeMinusMoney != "") {
            let newMinusMoney = MinusMoney()
            let uuid = UUID().uuidString
            
            newMinusMoney.id = uuid
            newMinusMoney.type = typeMinusMoney
            newMinusMoney.name = nameOfMinusMoney.text!
            newMinusMoney.amount = Int(amountOfMinusMoney.text!)!
            newMinusMoney.category = categoryMinusMoney
            
            try! realmMinusMoney.write{
                realmMinusMoney.add(newMinusMoney)
            }
            nameOfMinusMoney.text = ""
            amountOfMinusMoney.text = ""
        } else{
            let alert = UIAlertController(title: "Упс!", message: "Вы забыли ввести свой расход!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Попробовать еще раз", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }

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
