//
//  GoalAllViewController.swift
//  scheduling
//
//  Created by Marten on 7/4/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit
import CoreData

class GoalAllViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var addGoalView: UIView!
    
    var goal_count : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
        loadGoal_CategoryData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadGoal_CategoryData(){
        
        let queryStatementString = "SELECT * FROM Goal_Category;"
        
        if get_sql(queryString: queryStatementString) == false { return}
        
        goal_count = queryResult.count
        
        for i in 0..<goal_count
        {
            addView(title: "   "+queryResult[i][1],number: i,key: Int(queryResult[i][0]) ?? 0)
        }
       // dropDown.heightConstraint
        
    }
    func addView(title : String,number : Int,key: Int) {
        
        let width = addGoalView.frame.width
        let goal_view = UIView(frame: CGRect(x: 0.0, y: 20.0+(Double)(number) * 40.0, width: Double(width - 10), height: 39))
        
        addDtailButton(parent: goal_view,key: key)
        addGoalLabel(parent: goal_view,title: title,number: number)
        addGoalView.addSubview(goal_view)
        addLine(number: number)
        
        
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
        let width = addGoalView.frame.width
        let lineView = UIView(frame: CGRect(x: 10.0, y: 60.0+(Double)(number) * 40.0, width: Double(width - 10), height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor =  UIColor(red: 203/255, green: 203/255, blue: 207/255, alpha: 1).cgColor
        addGoalView.addSubview(lineView)
        
    }
    func addDtailButton(parent : UIView,key : Int)
    {
        
        let button = CustomUIButton()
        button.frame = CGRect(x: parent.frame.width - 80, y: 5, width: 75, height: parent.frame.height-10)
        button.backgroundColor = UIColor.clear
        button.setBackgroundImage(UIImage(named: "detail.png"), for: .normal)
        button.addTarget(self, action: #selector(detailBtAction), for: .touchUpInside)
        button.private_key = key
        parent.addSubview(button)

    }
    @objc func detailBtAction(sender: CustomUIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GoalEditController") as! GoalEditController
        for ve in sender.superview!.subviews{
            if ve is UILabel{
                vc.viewTitle = (ve as! UILabel).text ?? " "
                vc.goal_key = sender.private_key
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
