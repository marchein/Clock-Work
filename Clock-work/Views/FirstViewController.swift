//
//  ViewController.swift
//  Clockin
//
//  Created by Noam Efergan on 03/05/2020.
//  Copyright © 2020 Noam Efergan. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController {
    
    // remove navigation bar
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //outlets
    
    @IBOutlet weak var infoLabel: UILabel!
    
    // variables
    
    let myTime = Times()
    let data = realm.objects(Data.self)
    let times = realm.objects(Times.self)
    var first = ""
    var second = ""
    var timesWorked:(Int,Int) = (0,0)
    var hourlyWage:Double = 0.0
    var petrolMoney:Double = 0.0
    var contractSelected:Int = 0
    var extraHours:Int = 0
    var shiftSalary:Double = 0.0
    var monthSalary:Double = 0.0
    var monthlyHours:(Int,Int) = (0,0)
    
    // MARK 1 - view loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iPhone XR-XS Max-11 – 1.png")!)
        check()
        infoLabel.text = """
        You've made this shift: \(String(format: "%.2f", shiftSalary)) euros
        You've made this month: \(String(format: "%.2f", monthSalary)) euros
        You've worked \(monthlyHours.0) hours and \(monthlyHours.1) minutes this month


"""
        
    }

    // MARK 2 - buttons
    
    @IBAction func clockinWasPressed(_ sender: UIButton) {
        first = Brain.grabTime()
        myTime.start = first
        try! realm.write{
            if !times.isEmpty{
                times.first?.start = first
                
            }
            else {
                realm.add(myTime)
            }
        }
        Brain.animateButton(sender: sender)
        

    }
    
    @IBAction func clockoutWasPressed(_ sender: UIButton) {
        second = Brain.grabTime()
        let result = Brain.findDateDiff(time1Str: first, time2Str: second)
        timesWorked = Brain.split(interval: result)
        print("hours:\(timesWorked.0)" + "minutes: \(timesWorked.1)")
        if extraHours == 1 {
            hourlyWage = hourlyWage * 1.5
        }
        let total = Brain.calculation(hourlyWage: hourlyWage, contractType: contractSelected, hoursWorked: timesWorked.0, minutesWorked: timesWorked.1, petrolMoney: petrolMoney)
        shiftSalary = total
        tallyUp(shift: shiftSalary, month: monthSalary, hours: timesWorked.0, minutes: timesWorked.1)
        infoLabel.text = """
        You've made this shift: \(String(format: "%.2f", shiftSalary)) euros
        You've made this month: \(String(format: "%.2f", monthSalary)) euros
        You've worked \(monthlyHours.0) hours and \(monthlyHours.1) minutes this month
        """
        
        Brain.animateButton(sender: sender)
        
    }
    

        func check() {
        if let mid = times.first?.start{
            first = mid
        }
        if let a = data.first?.hourlyWage{
            hourlyWage = a
        }
        if let b = data.first?.contractSelected{
            contractSelected = b
        }
        if let c = data.first?.petrolMoney{
            petrolMoney = c
        }
        if let d = data.first?.extraHours{
            extraHours = d
        }
        if let e = times.first?.monthlyHours{
            monthlyHours.0 = e
            }
        if let f = times.first?.monthlyMinutes{
            monthlyHours.1 = f
            }
        if let g = times.first?.monthlySalary{
            monthSalary = g
            }
    }
    
    func tallyUp(shift:Double, month: Double,hours:Int,minutes:Int){
        monthSalary = month + shift
        monthlyHours.0 = monthlyHours.0 + hours
        monthlyHours.1 = monthlyHours.1 + minutes
        
        try! realm.write{
            times.first?.monthlyHours = monthlyHours.0
            times.first?.monthlyMinutes = monthlyHours.1
            times.first?.monthlySalary = monthSalary
        }
    }
    
    @IBAction func infoWasPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Legal", message: "Privacy policy and term and conditions", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Pricacy", style: .default, handler: { (alert) in
            let url = URL(string: "https://clock-work.flycricket.io/privacy.html")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Terms and conditions", style: .default, handler: { (alert) in
            let url = URL(string: "https://clock-work.flycricket.io/terms.html")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true)
    }
    
    
}

