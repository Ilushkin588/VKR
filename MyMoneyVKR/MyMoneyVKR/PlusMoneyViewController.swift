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


class PlusMoneyViewController: UIViewController {
    
    @IBOutlet weak var plusCategoriesCollection: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender: self)
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