//
//  AddActionViewController.swift
//  scheduling
//
//  Created by Marten on 6/25/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class AddActionViewController: UIViewController {

   
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var task_count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
        
        loadTask_CategoryData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadTask_CategoryData(){
        
        let queryStatementString = "SELECT * FROM Task_Category;"
        
        if get_sql(queryString: queryStatementString) == false { return}
        
        task_count = queryResult.count
        
        for i in 0..<task_count
        {
            addTask(title: "   "+queryResult[i][1],number: i,key: Int(queryResult[i][0]) ?? 0)
        }
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.cornerRadius = 5
        
        
    }
    func addTask(title : String, number : Int,key: Int)
    {
        let Width = taskView.frame.width         //343
        let Height = taskView.frame.height     //523
        
        let button = CustomUIButton(frame: CGRect(x: 0, y: Int(Height*4/100+Height*7/100 * CGFloat(number)), width : Int(Width), height: Int(Height*6.5/100)))
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: button.frame.height*60/100, weight: .bold)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = goal_Color[number % goal_Color.count].cgColor
        button.private_key = key
        button.addTarget(self, action: #selector(taskBtAction), for: .touchUpInside)
        
        taskView.addSubview(button)
        
    }
    @objc func taskBtAction(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActionAddController") as! ActionAddController
        vc.viewTitle = (sender as! CustomUIButton).title(for: .normal)!
        vc.task_key = (sender as! CustomUIButton).private_key
        
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
