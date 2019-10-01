//
//  ActionDetailController.swift
//  scheduling
//
//  Created by Marten on 7/3/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class ActionDetailController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var addAlarmBtn: UIButton!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var dueDateView: SSCalendarView!
    @IBOutlet weak var titleBtn: UILabel!
    @IBOutlet weak var repeat_T: UISegmentedControl!
    
    var viewTitle : String = "Task Title"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
        
        dueDateView.layer.borderWidth = 1
        dueDateView.layer.borderColor = UIColor.black.cgColor
        dueDateView.layer.cornerRadius = 10
        
        
        repeat_T.frame = CGRect(x: 20, y: 486, width: 320, height: 40)
        
        for segment in repeat_T.subviews{
          for label in segment.subviews{
            if label is UILabel{
                (label as! UILabel).numberOfLines = 2
             }
           }
        }
        
        initLoad()
    }
    func initLoad(){
        
        titleBtn.text = viewTitle
        
        alarmSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        alarmSwitch.addTarget(self, action: #selector(statueChanged), for: .valueChanged)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAlarm))  //Long function will call when user long press on button.
        addAlarmBtn.addGestureRecognizer(longGesture)
        
        calendarInitialSetup()
        
    }
    @objc func addAlarm() {
        
        let vc = SambagTimePickerViewController()
        vc.theme = .light
        vc.delegate = self
        
        vc.view.frame = CGRect(x: reminderLabel.frame.origin.x + reminderLabel.frame.size.width / 2, y: backgroundView.frame.size.height / 2 - 200, width: vc.view.frame.size.width * 3 / 4, height: vc.view.frame.size.height * 2 / 3)
        vc.view.layer.shadowColor = UIColor.black.cgColor
        vc.view.layer.shadowOpacity = 1
        vc.view.layer.shadowOffset = .zero
        vc.view.layer.shadowRadius = 10
        
        present(vc, animated: true, completion: nil)
        
    }
    @objc func statueChanged(switchState: UISwitch) {
        
        if switchState.isOn {
            
            addAlarmBtn.isEnabled = true
            addAlarmBtn.isHighlighted = false
            
        } else {
            
            addAlarmBtn.isHighlighted = true
            addAlarmBtn.isEnabled = false
            
            
        }
    }
    fileprivate func calendarInitialSetup() {
        
        self.dueDateView.delegate = self as? SSCalendarDeleagte
        setupCalendar(calendarView : dueDateView)
        
    }
    fileprivate func setupCalendar(calendarView : SSCalendarView!) {
        /// Configuration
        calendarView.configuration.monthViewBackgroundColor = UIColor.white
        calendarView.configuration.monthViewBottomLineColor = UIColor.darkGray
        calendarView.configuration.weekDayLabelBackgroundColor = UIColor.clear
        calendarView.configuration.weekDayLabelTextColor = UIColor.black
        calendarView.configuration.previousDayTextColor = UIColor.black
        calendarView.configuration.previousDayBorderColor = UIColor.clear
        calendarView.configuration.upcomingDaysBorderColor = UIColor.clear
        calendarView.configuration.monthLabelFont = UIFont.systemFont(ofSize: 13,weight: .bold)
        calendarView.configuration.dayLabelFont = UIFont.systemFont(ofSize: 10)
        calendarView.configuration.weekDayLabelFont = UIFont.systemFont(ofSize: 13,weight: .bold)
        calendarView.configuration.monthLabelTextColor = UIColor.red
        calendarView.configuration.upcomingDaysBorderColor = UIColor.clear
        calendarView.configuration.upcomingDayTextColor = UIColor.brown
        calendarView.configuration.selectedDayTextColor = UIColor.yellow
        calendarView.configuration.currentDayBorderColor = UIColor.black
        calendarView.configuration.currentDayTextColor = UIColor.white
        calendarView.configuration.currentDayBackgroundColor = UIColor.red
        /// Setup
        // Calender start date and end date
        let startDate = SSConstants.todayDate
        let endDate = startDate.getDateAfter(years: 1, months: 1)
        calendarView.setUpCalendar(startDate: startDate, endDate: endDate, weekStartDay: .sunday, shouldSelectPastDays: true, sholudAllowMultipleSelection: false)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ActionDetailController: SambagTimePickerViewControllerDelegate {
    
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult) {
        //resultLabel.text = "\(result)"
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
