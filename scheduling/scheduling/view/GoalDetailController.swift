//
//  GoalDetailController.swift
//  scheduling
//
//  Created by Marten on 6/22/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit
import SQLite3
import EventKit

class GoalDetailController: UIViewController ,SSRadioButtonControllerDelegate{
    
    
    
    @IBOutlet weak var calendarView_1: SSCalendarView!
    
    @IBOutlet weak var calendarView_2: SSCalendarView!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var skipBt: UIButton!
    @IBOutlet weak var finishBt: UIButton!
    @IBOutlet weak var syncSwitch: UISwitch!
    @IBOutlet weak var goalName: UITextField!
    
    var radioButtonController: SSRadioButtonsController?
    
    var key : Int = 0
    
    var calendarDelegate_1 = CalendarView_1()
    var calendarDelegate_2 = CalendarView_2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        calendarView_1.layer.borderWidth = 1
        calendarView_1.layer.borderColor = UIColor.black.cgColor
        calendarView_1.layer.cornerRadius = 10
        
        calendarView_2.layer.borderWidth = 1
        calendarView_2.layer.borderColor = UIColor.black.cgColor
        calendarView_2.layer.cornerRadius = 10
      
        calendarDelegate_1.startDate = SSConstants.todayDate
        calendarDelegate_2.endDate = SSConstants.todayDate
            
        goalName.delegate=self as UITextFieldDelegate
        syncSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        syncSwitch.setOn(false, animated: true)
        
        initload();
        // Do any additional setup after loading the view.
        
        
        
        
    }
    func eventStoreSet(startDate : Date,endDate : Date) {
        
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
            case .authorized:
                insertEvent(store: eventStore,startDate: startDate,endDate: endDate)
            case .denied:
                print("Access denied")
            case .notDetermined:
                // 3
                eventStore.requestAccess(to: .event, completion:
                    {[weak self] (granted: Bool, error: Error?) -> Void in
                        if granted {
                            self!.insertEvent(store: eventStore,startDate: startDate,endDate: endDate)
                        } else {
                            print("Access denied")
                        }
                })
            default:
                print("Case default")
        }
    }
    func insertEvent(store: EKEventStore, startDate : Date,endDate : Date) {
        // 1
        let calendars = store.calendars(for: .event)
        
        for calendar in calendars {
            // 2
            if calendar.title == "Calendar" {
                // 4
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = self.goalName.text
                event.startDate = startDate
                event.endDate = endDate
                
                // 5
                do {
                    try store.save(event, span: .thisEvent)
                }
                catch {
                    print("Error saving event in calendar")             }
            }
        }
    }
    ////////////////////////////////////////////////////////////////
    func initload()
    {
        calendarInitialSetup()
        //customRadioButtonController()
        //syncAddButton()
        addBottomButton()
        
    }
    func addBottomButton()
    {
        skipBt.layer.borderWidth = 2
        skipBt.layer.borderColor = UIColor.black.cgColor
        skipBt.layer.cornerRadius = 10
        
        finishBt.layer.borderWidth = 2
        finishBt.layer.borderColor = UIColor.black.cgColor
        finishBt.layer.cornerRadius = 10
        
    }
    func customRadioButtonController()
    {
        radioButtonController = SSRadioButtonsController()
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
    }
    func syncAddButton() {
        
        let Width = subView.frame.width  //343
        let Height = subView.frame.height  //554
        
        let radioButton = SSRadioButton()
        radioButton.circleColor = .red
        radioButton.circleRadius = Width*2.5/100
        radioButton.frame = CGRect(x: Int(Width*15/100.0), y: Int(Height*85/100.0), width: Int(Width*90/100.0), height: Int(Height*3/100.0))
        radioButton.setTitle(" Sync to Calendar", for: .normal)
        radioButton.setTitleColor(UIColor.black, for: .normal)
        radioButton.titleLabel?.font =  UIFont.systemFont(ofSize: Width*4/100.0, weight: .bold)
        radioButton.contentHorizontalAlignment = .left
        //    radioButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        subView.addSubview(radioButton)
        radioButtonController?.addButton(radioButton)
        
    }
    fileprivate func calendarInitialSetup() {
        calendarView_1.delegate = calendarDelegate_1
        calendarView_2.delegate = calendarDelegate_2
        setupCalendar(calendarView : calendarView_1)
        setupCalendar(calendarView : calendarView_2)
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
    func didSelectButton(selectedButton: UIButton?) {
        
    }
  
    @IBAction func finishAction(_ sender: Any){
        
        if goalName.text?.isEmpty == true {

            let alert = UIAlertController(title: "Input Error!", message: "Please insert correct all value!", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)

            return

        }
        var queryStatement: OpaquePointer? = nil
        
        var queryString = "SELECT COUNT(*) FROM Sub_Goal where key = ? and title = ?"
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(queryStatement, 1, NSString(string: String(key)).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 2, NSString(string: goalName.text!).utf8String, -1, nil)
            
            while(sqlite3_step(queryStatement) == SQLITE_ROW){
                let count = sqlite3_column_int(queryStatement, 0)
                if count > 0{
                    let alert = UIAlertController(title: "Input Error!", message: "Please Same title exist already!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                    return
                    
                }
            }
            
        }
        sqlite3_finalize(queryStatement)
        
        queryString = "INSERT INTO Sub_Goal (key, title,start,end) VALUES (?, ?, ?, ?);"
        var insertStr : [String] = []
        insertStr.append(String(key))
        insertStr.append(goalName.text!)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        var result = formatter.string(from: calendarDelegate_1.startDate)
        insertStr.append(result)
        
        result = formatter.string(from: calendarDelegate_2.endDate)
        insertStr.append(result)

        if insert_sql(queryString: queryString,insertData: insertStr as [NSString]) == false { return}
        if syncSwitch.isOn == true
        { eventStoreSet(startDate: calendarDelegate_1.startDate,endDate: calendarDelegate_2.endDate);}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
extension GoalDetailController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        self.updateSaveButtonState()
        
    }
}
class CalendarView_1 :SSCalendarDeleagte{
    
    var startDate : Date = SSConstants.todayDate
    
    
    func dateSelected(_ date: Date) {
      
        
        startDate = date
        
    }
    
    func dateDeSelected(_ date: Date) {
        
    }
    
    
}
class CalendarView_2 :SSCalendarDeleagte{
    
    var endDate : Date = SSConstants.todayDate
    
    func dateSelected(_ date: Date) {
      
        endDate = date
        
    }
    
    func dateDeSelected(_ date: Date) {
        
    }
    
    
}
