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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var gestureOutlet: UITapGestureRecognizer!
    
    @IBAction func gesture(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newPlusMoneyButton(_ sender: Any) {
        }
        
    @IBAction func newMinusMoneyButton(_ sender: Any) {
        }
    
   
    
    @IBOutlet var viewForDismissTap: UIView!
    
    
    func screenTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tapGesture.numberOfTapsRequired = 1
        viewForDismissTap.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

