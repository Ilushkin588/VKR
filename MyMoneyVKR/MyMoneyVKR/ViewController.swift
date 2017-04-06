//
//  ViewController.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 28.03.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import UIKit
import RealmSwift
import TextFieldEffects

class ViewController: UIViewController {
    
//    let realmPlusMoney = try! Realm()
  //  let NewPlusMoney = PlusMoney()
    //let realmMinusMoney = try! Realm()
    //let NewMinusMoney = MinusMoney()

    
    
    
    @IBAction func newPlusMoneyButton(_ sender: Any) {
     //   NewPlusMoney.name = NamePlusMoney.text!
       // NewPlusMoney.amount = PlusMoneyTextField.text!
        
      //  try! realmPlusMoney.write{
        //    realmPlusMoney.add(NewPlusMoney)
        }
        
        //NamePlusMoney.text = ""
        //PlusMoneyTextField.text = ""
    
        
    @IBAction func newMinusMoneyButton(_ sender: Any) {
        //NewMinusMoney.name = NamePlusMoney.text!
        //NewMinusMoney.amount = PlusMoneyTextField.text!
        
   //     try! realmMinusMoney.write{
     //       realmMinusMoney.add(NewMinusMoney)
        }
        
        //NamePlusMoney.text = ""
        //PlusMoneyTextField.text = ""

    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
   
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

