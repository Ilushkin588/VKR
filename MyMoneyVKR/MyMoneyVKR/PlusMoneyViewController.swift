//
//  PlusMoneyViewController.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 30.03.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import UIKit
import RealmSwift
import TextFieldEffects

//protocol PlusBalanceDelegate {
  //  func fillTheLabelWith(info: String)
//}

class PlusMoneyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
   // var delegate: PlusBalanceDelegate?
    
    let realmPlusMoney = try!Realm()
    var categoryPlusMoney = ""
    var typePlusMoney = ""
    var plusBalance = 0
    
    @IBOutlet weak var nameOfPlusMoney: UITextField!
    @IBOutlet weak var amountOfPlusMoney: UITextField!
    
    
    let plusMoneyCellReuseIdentifier = "cell"
    let itemsPlusMoney = ["Зарплата", "Бизнес", "Долги", "Подарок", "Проценты", "Сбережения"]
    let plusMoneyImageArray = [UIImage(named:"salary"), UIImage(named:"business"), UIImage(named:"debts"), UIImage(named:"present"), UIImage(named:"procents"), UIImage(named:"savings")]
    
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    
    // Выбор типа дохода
    @IBAction func typeChooseSegmentControl(_ sender: Any) {
        switch typeSegmentControl.selectedSegmentIndex{
    case 0:
        typePlusMoney = "Наличные"
    case 1:
        typePlusMoney = "Карта"
    default:
        break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.plusMoneyImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: plusMoneyCellReuseIdentifier, for: indexPath) as! PlusCollectionViewCell
        cell.imageCategory?.image = self.plusMoneyImageArray[indexPath.row]
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        categoryPlusMoney =  self.itemsPlusMoney[indexPath.row]
        
    }
    
    //Добавление объекта(дохода)
    @IBAction func addPlusMoneyButton(_ sender: Any) {
        if (nameOfPlusMoney.text! != "" && amountOfPlusMoney.text! != "" && categoryPlusMoney != "" && typePlusMoney != "") {
            //let inform = amountOfPlusMoney.text
            //delegate?.fillTheLabelWith(info: inform!)
            //navigationController?.popViewController(animated: true)
            
            let newPlusMoney = PlusMoney()
            let uuid = UUID().uuidString
        
            newPlusMoney.id = uuid
            newPlusMoney.type = typePlusMoney
            newPlusMoney.name = nameOfPlusMoney.text!
            newPlusMoney.amount = Int(amountOfPlusMoney.text!)!
            newPlusMoney.category = categoryPlusMoney
        
                try! realmPlusMoney.write{
                    realmPlusMoney.add(newPlusMoney)
                            }
            nameOfPlusMoney.text = ""
            amountOfPlusMoney.text = ""
        } else{
            let alert = UIAlertController(title: "Упс!", message: "Вы забыли ввести свой доход!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Попробовать еще раз", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    var plusList : Results<PlusMoney>!
    func readPlusMoneyAndUpdateUI(){
        plusList = realmPlusMoney.objects(PlusMoney.self)
        for plus in plusList{
            plusBalance += plus.amount
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
