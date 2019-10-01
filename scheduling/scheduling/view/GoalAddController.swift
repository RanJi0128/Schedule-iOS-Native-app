//
//  GoalAddController.swift
//  scheduling
//
//  Created by Marten on 6/22/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit
import iOSDropDown
import SQLite3

class GoalAddController: UIViewController {
    
    @IBOutlet var goalView: UIView!
    @IBOutlet weak var goalCategoryTitle: UILabel!
    @IBOutlet weak var addSubGoalBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var titleText: UITextField!
    {
        didSet {
            titleText.text = " "
        }
    }
    @IBOutlet weak var reasonText: UITextField!
    @IBOutlet weak var noteText: UITextField!
    
    
    @IBOutlet weak var categoryView: DropDown!{
        didSet {
            categoryView.layer.cornerRadius =  5
            categoryView.layer.borderColor = UIColor.black.cgColor
            categoryView.layer.borderWidth = 2
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
            categoryView.leftView = leftView
            categoryView.leftViewMode = .always
        }
    }
    @IBOutlet weak var reminderView: DropDown!{
        didSet {
            reminderView.layer.cornerRadius =  5
            reminderView.layer.borderColor = UIColor.black.cgColor
            reminderView.layer.borderWidth = 2
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
            reminderView.leftView = leftView
            reminderView.leftViewMode = .always
        }
    }
    @IBOutlet weak var priorityView: DropDown!{
        didSet {
            priorityView.layer.cornerRadius =  5
            priorityView.layer.borderColor = UIColor.black.cgColor
            priorityView.layer.borderWidth = 2
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
            priorityView.leftView = leftView
            priorityView.leftViewMode = .always
            
        }
    }
    
    let screenBounds = UIScreen.main.bounds
    var viewTitle : String = "Goal Category Title"
    var key : Int = 0
    var id_num : Int = 0
    var isUpdate : Bool = false
    let priorityColor = [UIColor.green, UIColor(red: 1, green: 197/255, blue: 0, alpha: 1), UIColor.red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        titleText.delegate=self as UITextFieldDelegate
        reasonText.delegate=self as UITextFieldDelegate
        noteText.delegate=self as UITextFieldDelegate
        
        goalView.layer.borderWidth = 3
        goalView.layer.borderColor = UIColor.black.cgColor
        
        initload()
        
        var date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yy"
        var result = formatter.string(from: date)
        startDate.text = result
        
        date.changeDays(by: 7)
        result = formatter.string(from: date)
        endDate.text = result
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initload()
    {
        goalCategoryTitle.text = viewTitle
        
        addGoalCategory()
        addGoalReminder()
        addGoalPriority()
        addBottomButton()
        
        if isUpdate == true {
            updateShow()
        }
        
        
    }
    func addBottomButton()
    {
        addSubGoalBtn.layer.borderWidth = 2
        addSubGoalBtn.layer.borderColor = UIColor.black.cgColor
        addSubGoalBtn.layer.cornerRadius = 10
        
        finishBtn.layer.borderWidth = 2
        finishBtn.layer.borderColor = UIColor.black.cgColor
        finishBtn.layer.cornerRadius = 10
        
    }
    func addGoalCategory()
    {
        // The list of array to display. Can be changed dynamically
        categoryView.optionArray = ["Weekly", "Monthly", "Quarterly","Annually"]
        //Its Id Values and its optional
        categoryView.optionIds = [1,23,54,22]
        // The the Closure returns Selected Index and String
        categoryView.selectedIndex = 0
        categoryView.text = categoryView.optionArray[0]
        categoryView.didSelect{(selectedText , index ,id) in
     
            var date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yy"
            
            switch index {
                case 0:
                    date.changeDays(by: 7)
                    let result = formatter.string(from: date)
                    self.endDate.text = result
                    break
                case 1:
                     var dateComponent = DateComponents()
                     dateComponent.month = 1
                     let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
                     let result = formatter.string(from: futureDate ?? date)
                     self.endDate.text = result
                    break
                case 2:
                    
                    var dateComponent = DateComponents()
                    dateComponent.month = 3
                    let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
                    let result = formatter.string(from: futureDate ?? date)
                    self.endDate.text = result
                    break
                case 3:
                    var dateComponent = DateComponents()
                    dateComponent.year = 1
                    let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
                    let result = formatter.string(from: futureDate ?? date)
                    self.endDate.text = result
                    break
                default: break
                
            }
            self.categoryView.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        
    }
    func addGoalReminder()
    {
        // The list of array to display. Can be changed dynamically
        reminderView.optionArray = ["Daily","Weekly", "Monthly", "Quarterly"]
        //Its Id Values and its optional
        reminderView.optionIds = [1,23,54,22]
        // The the Closure returns Selected Index and String
        reminderView.selectedIndex = 0
        reminderView.text = reminderView.optionArray[0]
        reminderView.didSelect{(selectedText , index ,id) in
            self.reminderView.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        
    }
    func addGoalPriority()
    {
        priorityView.optionArray = ["Low","Medium", "High"]
        //Its Id Values and its optional
        priorityView.optionIds = [1,23,54,22]
        // The the Closure returns Selected Index and String
        priorityView.selectedIndex = 0
        priorityView.text = priorityView.optionArray[0]
        priorityView.didSelect{(selectedText , index ,id) in
            self.priorityView.text = "Selected String: \(selectedText) \n index: \(index)"
            
            self.priorityView.textColor = self.priorityColor[index]
        }
        
    }
    @IBAction func okAction(_ sender: Any){
        
//        if titleText.text?.isEmpty == true || reasonText.text?.isEmpty == true || noteText.text?.isEmpty == true{
//
//            let alert = UIAlertController(title: "Input Error!", message: "Please insert correct all value!", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true)
//
//            return
//
//        }
//        var queryStatement: OpaquePointer? = nil
//
//        let queryString = "SELECT COUNT(*) FROM Goal where key = ? and title = ?"
//        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
//
//            sqlite3_bind_text(queryStatement, 1, NSString(string: String(key)).utf8String, -1, nil)
//            sqlite3_bind_text(queryStatement, 2, NSString(string: titleText.text!).utf8String, -1, nil)
//
//            while(sqlite3_step(queryStatement) == SQLITE_ROW){
//                let count = sqlite3_column_int(queryStatement, 0)
//                if count > 0{
//                    let alert = UIAlertController(title: "Input Error!", message: "Please Same title exist already!", preferredStyle: .alert)
//
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    self.present(alert, animated: true)
//
//                    return
//
//                }
//            }
//
//        }
//        sqlite3_finalize(queryStatement)
//
        var queryStatementString = "INSERT INTO Goal (key, title,schedule,reminder,priority,reason,note,startdate,enddate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
//        var insertStr : [String] = []
//        insertStr.append(String(key))
//        insertStr.append(titleText.text!)
//        insertStr.append(String(categoryView.selectedIndex!))
//        insertStr.append(String(reminderView.selectedIndex!))
//        insertStr.append(String(priorityView.selectedIndex!))
//        insertStr.append(reasonText.text!)
//        insertStr.append(noteText.text!)
//        insertStr.append(startDate.text!)
//        insertStr.append(endDate.text!)
//
//        if insert_sql(queryString: queryStatementString,insertData: insertStr as [NSString]) == false { return}
        
        queryStatementString = "SELECT * FROM Goal;"
        if get_sql(queryString: queryStatementString) == false { return}
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GoalDetailController") as! GoalDetailController
        vc.key = Int((queryResult.last?.first)!)!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func updateShow() {
        
        if id_num == 0 {return}
        let queryStatementString = "SELECT * FROM Goal where id = \(id_num);"
        if get_sql(queryString: queryStatementString) == false { return}
    
        titleText.text = queryResult[0][2]
//        print("call-------->String(describing: titleText.text)")
       
        reminderView.selectedIndex = Int(queryResult[0][4])
        priorityView.selectedIndex = Int(queryResult[0][5])
        reasonText.text = queryResult[0][6]
        noteText.text = queryResult[0][7]
        startDate.text = queryResult[0][8]
        endDate.text = queryResult[0][9]
        
        
    }
    @IBAction func finishAction(_ sender: Any){
        
        if titleText.text?.isEmpty == true || reasonText.text?.isEmpty == true || noteText.text?.isEmpty == true{
            
            let alert = UIAlertController(title: "Input Error!", message: "Please insert correct all value!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
            
        }
        var queryStatement: OpaquePointer? = nil
        
        let queryString = "SELECT COUNT(*) FROM Goal where key = ? and title = ?"
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(queryStatement, 1, NSString(string: String(key)).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 2, NSString(string: titleText.text!).utf8String, -1, nil)
            
            while(sqlite3_step(queryStatement) == SQLITE_ROW){
                let count = sqlite3_column_int(queryStatement, 0)
                print("\(count)")
                if count > 0{
                    let alert = UIAlertController(title: "Input Error!", message: "Please Same title exist already!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                    return
                    
                }
            }
            
        }
        sqlite3_finalize(queryStatement)
        
        var queryStatementString = "INSERT INTO Goal (key, title,schedule,reminder,priority,reason,note) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStr : [String] = []
        insertStr.append(String(key))
        insertStr.append(titleText.text!)
        insertStr.append(String(categoryView.selectedIndex!))
        insertStr.append(String(reminderView.selectedIndex!))
        insertStr.append(String(priorityView.selectedIndex!))
        insertStr.append(reasonText.text!)
        insertStr.append(noteText.text!)
        
        if insert_sql(queryString: queryStatementString,insertData: insertStr as [NSString]) == false { return}
        
        queryStatementString = "SELECT * FROM Goal;"
        if get_sql(queryString: queryStatementString) == false { return}
        
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
extension Date {
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
extension GoalAddController : UITextFieldDelegate {
    
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
