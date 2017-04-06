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

class PlusMoneyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let realmMoney = try!Realm()
    let newPlusMoney = PlusMoney()
    
    @IBOutlet weak var nameOfPlusMoney: UITextField!
    @IBOutlet weak var amountOfPlusMoney: UITextField!
    
    
    let reuseIdentifier = "cell"
    let items = ["💶 Зарплата", "🏢 Бизнес", "💸 Долги", "🎁 Подарок", "🏦 Проценты", "📦 Сбережения"]
    let imageArray = [UIImage(named:"salary"), UIImage(named:"business"), UIImage(named:"debts"), UIImage(named:"present"), UIImage(named:"procents"), UIImage(named:"savings")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlusCollectionViewCell
        cell.imageCategory?.image = self.imageArray[indexPath.row]
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        newPlusMoney.category = self.items[indexPath.row]
        //print(newPlusMoney.category)
    }
    
    
    @IBAction func addPlusMoneyButton(_ sender: Any) {
        self.newPlusMoney.realm?.beginWrite()
        newPlusMoney.name = nameOfPlusMoney.text!
        newPlusMoney.amount = amountOfPlusMoney.text!
        self.newPlusMoney.realm?.cancelWrite()
        
            try! realmMoney.write{
            realmMoney.add(newPlusMoney, update: true)
            //realmMoney.add(newPlusMoney)
        }
        nameOfPlusMoney.text = ""
        amountOfPlusMoney.text = ""
    
    //    try! realmMoney.write{
    //realmMoney.add(newPlusMoney, update: true)
    //}
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
