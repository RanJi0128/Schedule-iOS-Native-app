//
//  SubGoalEditController.swift
//  scheduling
//
//  Created by Marten on 7/4/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class SubGoalEditController: UIViewController {

  
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var showCompleteBtn: UIButton!
    @IBOutlet weak var subgoal_view: UIView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var reminder: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var celebrate: UITextField!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var boder: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var subgoal_key : Int = 0
    
    var row_count : Int = 0
    
    var viewTitle : String = "Sub Goal Title"
    var categoryTitle : String = "Goal Category Title"
    var reminderText : String = "Daily"
    var startDateText : String = "00-00-00"
    var endDateText : String = "00-00-00"
    var priorityText : String = "High"
    var reasonText : String = "Good"
    var celebrateText : String = "Hi"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        var paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.reason.frame.height))
        reason.leftView = paddingView
        reason.leftViewMode = UITextField.ViewMode.always

        paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.celebrate.frame.height))
        celebrate.leftView = paddingView
        celebrate.leftViewMode = UITextField.ViewMode.always
        
        initload()
    }
    func initload(){
        
        goalTitle.text = viewTitle
        categoryName.text = categoryTitle
        reminder.text = reminderText
        priority.text = priorityText
        reason.text = reasonText
        celebrate.text = celebrateText
        startDate.text = startDateText
        endDate.text = endDateText
        
        editBtn.addTarget(self, action: #selector(editBtAction), for: .touchUpInside)
        
        if subgoal_key == 0 {return}
        
        let queryStatementString = "SELECT * FROM Sub_Goal where key = \(subgoal_key);"
        
        if get_sql(queryString: queryStatementString) == false { return}
        
        row_count = queryResult.count
        
        var find_count : Int = 0
        
        for i in 0..<row_count
        {
            addView(title: "   "+queryResult[i][1],number: find_count)
            find_count += 1
            
        }
        
        showCompleteBtn.layer.borderWidth = 1
        showCompleteBtn.layer.borderColor = UIColor.black.cgColor
        showCompleteBtn.layer.cornerRadius = 12
        
    }
    
    func addView(title : String,number : Int) {
        
        let width = subgoal_view.frame.width
        let goal_view = UIView(frame: CGRect(x: 0.0, y: Double(boder.frame.origin.y)+10.0+(Double)(number) * 40.0, width: Double(width - 10), height: 25))
        addDtailButton(parent: goal_view)
        addGoalLabel(parent: goal_view,title: title,number: number)
        subgoal_view.addSubview(goal_view)
        addLine(number: number)
        
        
    }
    func addDtailButton(parent : UIView)
    {
        
        let button = CustomUIButton()
        button.frame = CGRect(x: parent.frame.width - 80, y: 2, width: 75, height: parent.frame.height-5)
        button.backgroundColor = UIColor.clear
        button.setBackgroundImage(UIImage(named: "detail.png"), for: .normal)
        button.addTarget(self, action: #selector(detailBtAction), for: .touchUpInside)
        parent.addSubview(button)
        
    }
    func addGoalLabel(parent : UIView,title : String,number : Int){
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 2, width: parent.frame.width - 85, height: parent.frame.height-5)
        label.backgroundColor = UIColor.clear
        
        label.text = title
        label.textColor = goal_Color[number  % goal_Color.count]
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: parent.frame.height * 55 / 100.0,weight: .bold)
        parent.addSubview(label)
        
        
    }
    func addLine(number : Int)
    {
        let width = subgoal_view.frame.width
        let lineView = UIView(frame: CGRect(x: 10.0, y: Double(boder.frame.origin.y)+30.0+(Double)(number) * 40.0, width: Double(width - 10), height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 203/255, green: 203/255, blue: 207/255, alpha: 1).cgColor
        subgoal_view.addSubview(lineView)
        
    }
    @objc func detailBtAction(sender: CustomUIButton) {
        
            
        
    }
    @objc func editBtAction(sender: UIButton) {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GoalAddController") as! GoalAddController
            vc.viewTitle = self.categoryTitle
            vc.id_num = subgoal_key;
            vc.isUpdate = true
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
