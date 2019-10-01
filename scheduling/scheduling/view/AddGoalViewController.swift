//
//  AddGoalViewController.swift
//  scheduling
//
//  Created by Marten on 6/21/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit
import CoreData

class AddGoalViewController: UIViewController {
    
    @IBOutlet var addGoalView: UIView!
    @IBOutlet weak var goalButtonView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
   // let screenBounds = UIScreen.main.bounds
    var goal_count : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addGoalView.layer.borderWidth = 3
        addGoalView.layer.borderColor = UIColor.black.cgColor
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
            addGoal(key: queryResult[i][0],title: "   "+queryResult[i][1],number: i)
        }
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.cornerRadius = 5
        

    }

    func addGoal(key: String, title : String, number : Int)
    {
        let Width = goalButtonView.frame.width         //343
        let Height = goalButtonView.frame.height     //523

        let button = CustomUIButton(frame: CGRect(x: 0, y: Int(Height*4/100+Height*7/100 * CGFloat(number)), width : Int(Width), height: Int(Height*6.5/100)))
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: button.frame.height*60/100, weight: .bold)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = goal_Color[number % goal_Color.count].cgColor
        button.private_key = Int(key) ?? 0
        button.addTarget(self, action: #selector(goalBtAction), for: .touchUpInside)
       
        goalButtonView.addSubview(button)
        
    }
    @objc func goalBtAction(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GoalAddController") as! GoalAddController
        vc.viewTitle = (sender as! CustomUIButton).title(for: .normal)!
        vc.key = (sender as! CustomUIButton).private_key
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
