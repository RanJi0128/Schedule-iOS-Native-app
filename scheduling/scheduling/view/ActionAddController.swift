//
//  ActoinAddController.swift
//  scheduling
//
//  Created by Marten on 6/30/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class ActionAddController: UIViewController {

    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var task_title: UILabel!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var showCompleteBtn: UIButton!
    
    
    var task_key : Int = 0
    
    var row_count : Int = 0
    
    var viewTitle : String = "Task_Category Title"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       backgroundView.layer.borderWidth = 1
       backgroundView.layer.borderColor = UIColor.blue.cgColor
        
       addTaskBtn.layer.borderWidth = 2
       addTaskBtn.layer.borderColor = UIColor.black.cgColor
       addTaskBtn.layer.cornerRadius = 10
        
        
        // Do any additional setup after loading the view.
        initload()
       
    }
    func initload()
    {
        task_title.text = viewTitle
        
        if task_key == 0 {return}
        
        let queryStatementString = "SELECT * FROM Task;"
        
        if get_sql(queryString: queryStatementString) == false { return}
        
        row_count = queryResult.count
        
        var find_count : Int = 0
        
        for i in 0..<row_count
        {
            if Int(queryResult[i][0]) == task_key{
                
                addView(title: queryResult[i][1],number: find_count,key: task_key)
                find_count += 1
            }
            
        }
        
        showCompleteBtn.layer.borderWidth = 1
        showCompleteBtn.layer.borderColor = UIColor.black.cgColor
        showCompleteBtn.layer.cornerRadius = 12
        
        
    }
    func addView(title : String,number : Int,key: Int) {
        
        let width = taskView.frame.width
        let offset_h = addTaskBtn.frame.size.height
        let task_view = UIView(frame: CGRect(x: 0.0, y: ((Double)(offset_h) + 15.0 + (Double)(number) * 40.0), width: Double(width - 10), height: 39))
        
        addCheckButton(parent: task_view)
        addDtailButton(parent: task_view,key: key)
        addTaskLabel(parent: task_view,title: title,number: number)
        taskView.addSubview(task_view)
        addLine(number: number)
        
        
    }
    func addTaskLabel(parent : UIView,title : String,number : Int){
        
        let label = UILabel()
        label.frame = CGRect(x: 25, y: 5, width: parent.frame.width - 85, height: parent.frame.height-10)
        label.backgroundColor = UIColor.clear
        
        label.text = title
        label.textColor = goal_Color[number  % goal_Color.count]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: parent.frame.height * 40 / 100.0,weight: .bold)
        parent.addSubview(label)
        
        
    }
    func addLine(number : Int)
    {
        let width = taskView.frame.width
        let lineView = UIView(frame: CGRect(x: 10.0, y: 90.0+(Double)(number) * 40.0, width: Double(width - 10), height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor =  UIColor(red: 203/255, green: 203/255, blue: 207/255, alpha: 1).cgColor
        taskView.addSubview(lineView)
        
    }
    func addCheckButton(parent : UIView)
    {
        
        let button = CheckBox()
        button.frame = CGRect(x: 10, y: 10, width: parent.frame.height-20, height: parent.frame.height-20)
        button.backgroundColor = UIColor.clear
        button.uncheckedImage=UIImage(named: "check-off")
        button.checkedImage=UIImage(named: "check-on")
        button.setImage(button.uncheckedImage, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(checkBtAction), for: .touchUpInside)
        parent.addSubview(button)
        
    }
    func addDtailButton(parent : UIView,key : Int)
    {
        
        let button = CustomUIButton()
        button.frame = CGRect(x: parent.frame.width - 80, y: 10, width: 75, height: parent.frame.height-20)
        button.backgroundColor = UIColor.clear
        button.setBackgroundImage(UIImage(named: "detail.png"), for: .normal)
        button.addTarget(self, action: #selector(detailBtAction), for: .touchUpInside)
        button.private_key = key
        parent.addSubview(button)
        
    }
    
    @objc func detailBtAction(sender: CustomUIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActionDetailController") as! ActionDetailController
        for ve in sender.superview!.subviews{
            if ve is UILabel{
                vc.viewTitle = (ve as! UILabel).text ?? " "
                
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func checkBtAction(sender: CheckBox) {
        
        sender.isChecked = !sender.isChecked
        
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
