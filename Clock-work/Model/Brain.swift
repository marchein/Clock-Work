//
//  Brain.swift
//  Clockin
//
//  Created by Noam Efergan on 03/05/2020.
//  Copyright © 2020 Noam Efergan. All rights reserved.
//

import UIKit
import RealmSwift

struct Brain {
    
    //split into hours and minutes
    
    static func split (interval:String) -> (Int,Int){
        let split = interval.split(separator: ":")
        print(split)
        let hours = Int(split[0]) ?? 0
        let minutes = Int(split[1]) ?? 0
        return (hours,minutes)
    }
    
    //find time difference
    
    static func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"
        
        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "" }
        
        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        return "\(intervalInt < 0 ? "" : "")\(Int(hour)):\(Int(minute))"
    }
    
    
    //animate button
    static func animateButton (sender: UIButton ){
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    // grab time
    static func grabTime() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return (formatter.string(from: currentDateTime))
    }
    
    static func calculation(hourlyWage: Double,contractType: Int, hoursWorked:Int, minutesWorked: Int, petrolMoney: Double) -> Double{
        var total:Double = 0.0
        
        // israeli contrac calculations
        if contractType == 0 {
            if hoursWorked <= 6{
               total = hourlyWage * 6 + petrolMoney
            }
            else {
            total = (hourlyWage * Double(hoursWorked) + ((hourlyWage / 60) * Double(minutesWorked)))
            total = total + petrolMoney
            }
        }
        
        // local contract calculations
        if contractType == 1 {
            if hoursWorked < 5{
                total = hourlyWage * 5 + petrolMoney
            }
            else if hoursWorked >= 5 && hoursWorked <= 8{
            total = (hourlyWage * Double(hoursWorked) + ((hourlyWage / 60) * Double(minutesWorked)))
            total = total + petrolMoney
            }
            else if hoursWorked > 8 {
                var mid = 0
                var dob:Double = 0.0
                total = hourlyWage * 8
                mid = hoursWorked - 8
                dob = hourlyWage * 1.5
                total = total + (Double(mid) * dob + ((hourlyWage / 60) * Double(minutesWorked)))
                total = total + petrolMoney
            }
        }
        
        return total
    }
    
    

    
}
// add done button

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
