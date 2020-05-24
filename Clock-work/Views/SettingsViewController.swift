//
//  SettingsViewController.swift
//  Clockin
//
//  Created by Noam Efergan on 03/05/2020.
//  Copyright © 2020 Noam Efergan. All rights reserved.
//

import UIKit
import RealmSwift
let realm = try! Realm()

class SettingsViewController: UIViewController {
    

    
    // all global veriables
    let myData = Data()
    let results = realm.objects(Data.self)
    let times = realm.objects(Times.self)
    var hourlyWage:Double = 0.0
    var petrolMoney:Double = 0.0
    var extraHours = 0
    var contractSelected = 0

    // all local outlets
    
    @IBOutlet weak var wageValue: UITextField!
    @IBOutlet weak var petrolValue: UITextField!
    @IBOutlet weak var contractImage: UIButton!
    @IBOutlet weak var extrahoursImage: UIButton!
    
    
    // view loaded
    
        override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iPhone XR-XS Max-11 – 1.png")!)
            wageValue.addDoneButtonOnKeyboard()
            petrolValue.addDoneButtonOnKeyboard()
            check()
            wageValue.text = "\(hourlyWage)"
            petrolValue.text = "\(petrolMoney)"
            extrahoursImage.setImage(UIImage (named: "Extra hours on"), for: .selected)
            extrahoursImage.setImage(UIImage (named: "Extra hours off"), for: .normal)
            contractImage.setImage(UIImage (named: "Contract Local"), for: .selected)
            contractImage.setImage(UIImage (named: "Contract Israeli"), for: .normal)
            
            
            

            
    }
    
    //all local buttons
    
    @IBAction func extraHoursWasPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            extraHours = 1
        }
        else{
            extraHours = 0
            
        }
        
    }
    
    @IBAction func contractWasPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected{
            contractSelected = 1
        }
        else {
            contractSelected = 0
        }

    }
    
    @IBAction func petrolAmount(_ sender: UITextField) {
        let text = petrolValue.text ?? "0.0"
        if let num = Double(text){
            petrolMoney = num
        }
        else {
            petrolMoney = 0.0
        }
        print(petrolMoney)
    }
    
    @IBAction func wageAmount(_ sender: UITextField) {
        let text = wageValue.text ?? "0.0"
        if let num = Double(text){
            hourlyWage = num
        }
        else {
            hourlyWage = 0.0
        }
        print(hourlyWage)
    }
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        myData.contractSelected = contractSelected
        myData.extraHours = extraHours
        myData.hourlyWage = hourlyWage
        myData.petrolMoney = petrolMoney
        try! realm.write{
            if !results.isEmpty{
            results.first?.hourlyWage = hourlyWage
            results.first?.contractSelected = contractSelected
            results.first?.petrolMoney = petrolMoney
            results.first?.extraHours = extraHours
            }
            else{
                realm.add(myData)
            }
        }
    }
    
    @IBAction func resetWasPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to reset", message: "This action is ireversable", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.destructive, handler: {(action:UIAlertAction!) in
            try! realm.write{
                self.times.first?.start = ""
                self.times.first?.monthlyHours = 0
                self.times.first?.monthlyMinutes = 0
                self.times.first?.monthlySalary = 0.0
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // functions
    
    func check (){
        if let a = results.first?.contractSelected {
            contractSelected = a
            if contractSelected == 0 {
                contractImage.isSelected = false
            }
            else if contractSelected == 1 {
                contractImage.isSelected = true
            }

        if let b = results.first?.hourlyWage{
            hourlyWage = b
            
        }
        if let c = results.first?.petrolMoney{
            petrolMoney = c
        }
        if let d = results.first?.extraHours{
            extraHours = d
            if extraHours == 0 {
                extrahoursImage.isSelected = false
            }
            else if extraHours == 1 {
                extrahoursImage.isSelected = true
            }
        }
}
}
}
