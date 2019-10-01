//
//  GoalEditController.swift
//  scheduling
//
//  Created by Marten on 7/4/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class GoalEditController: UIViewController {

   
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var showCompleteBtn: UIButton!
    
    var goal_key : Int = 0
    
    var row_count : Int = 0
    
    var viewTitle : String = "Goal Category Title"
    
    var result = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.blue.cgColor
        
        initload()
    }
    func initload(){
        
        goalTitle.text = viewTitle
        
        if goal_key == 0 {return}
        
        let queryStatementString = "SELECT * FROM Goal where key = \(goal_key);"
        
        if get_sql(queryString: queryStatementString) == false { return}
        
        result = queryResult;
        
        row_count = result.count
        
        var find_count : Int = 0
        
        for i in 0..<row_count
        {
            addView(title: "   "+result[i][2],number: find_count,sub_key: Int(result[i][0]) ?? 0)
            find_count += 1
          
        }
        
        showCompleteBtn.layer.borderWidth = 1
        showCompleteBtn.layer.borderColor = UIColor.black.cgColor
        showCompleteBtn.layer.cornerRadius = 12
        
    }
    func addView(title : String,number : Int,sub_key : Int) {
        
        let width = goalView.frame.width
        let goal_view = UIView(frame: CGRect(x: 0.0, y: 20.0+(Double)(number) * 40.0, width: Double(width - 10), height: 39))
        addDtailButton(parent: goal_view,sub_key: sub_key)
        addGoalLabel(parent: goal_view,title: title,number: number)
        goalView.addSubview(goal_view)
        addLine(number: number)
        
        
    }
    func addDtailButton(parent : UIView,sub_key : Int)
    {
        
        let button = CustomUIButton()
        button.frame = CGRect(x: parent.frame.width - 80, y: 5, width: 75, height: parent.frame.height-10)
        button.backgroundColor = UIColor.clear
        button.setBackgroundImage(UIImage(named: "detail.png"), for: .normal)
        button.addTarget(self, action: #selector(detailBtAction), for: .touchUpInside)
     
        let queryStatementString = "SELECT * FROM Sub_Goal where key = \(sub_key);"
        let subRowCount = get_sql(queryString: queryStatementString) ? queryResult.count : 0
        if subRowCount==0 {button.isEnabled = false}

        button.private_key = sub_key
        parent.addSubview(button)
        
    }
    func addGoalLabel(parent : UIView,title : String,number : Int){
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 5, width: parent.frame.width - 85, height: parent.frame.height-10)
        label.backgroundColor = UIColor.clear
        
        label.text = title
        label.textColor = goal_Color[number  % goal_Color.count]
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: parent.frame.height * 55 / 100.0,weight: .bold)
        parent.addSubview(label)
        
        
    }
    func addLine(number : Int)
    {
        let width = goalView.frame.width
        let lineView = UIView(frame: CGRect(x: 10.0, y: 60.0+(Double)(number) * 40.0, width: Double(width - 10), height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 203/255, green: 203/255, blue: 207/255, alpha: 1).cgColor
        goalView.addSubview(lineView)
        
    }
    @objc func detailBtAction(sender: CustomUIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubGoalEditController") as! SubGoalEditController
        vc.categoryTitle = viewTitle
        
        for i in 0..<row_count
        {
            if Int(result[i][0]) == sender.private_key{


               vc.startDateText = result[i][8]
               vc.endDateText  = result[i][9]
            switch result[i][5]
            {
                case "0":
                  vc.priorityText  = "Low"
                break
                case "1":
                  vc.priorityText  = "Medium"
                break
                case "2":
                  vc.priorityText  = "High"
                break
                default:
                  vc.priorityText  = "High"
            }
            switch result[i][4]
            {
                case "0":
                  vc.reminderText  = "Daily"
                break
                case "1":
                  vc.reminderText  = "Weekly"
                break
                case "2":
                  vc.reminderText  = "Monthly"
                break
                default:
                  vc.reminderText  = "Quarterly"
            }

               vc.reasonText  = result[i][6]
               vc.celebrateText  = result[i][7]
            }

        }
        for ve in sender.superview!.subviews{
            if ve is UILabel{
                vc.viewTitle = (ve as! UILabel).text ?? " "
                vc.subgoal_key = sender.private_key
            }
        }
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
