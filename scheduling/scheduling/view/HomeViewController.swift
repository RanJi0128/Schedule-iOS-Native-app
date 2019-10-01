//
//  HomeViewController.swift
//  scheduling
//
//  Created by Marten on 6/20/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var addGoalBtn: UIButton!
    @IBOutlet weak var taskMsg: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        addTaskBtn.layer.borderWidth = 2
        addTaskBtn.layer.borderColor = UIColor.black.cgColor
        addTaskBtn.layer.cornerRadius = 10
        
        addGoalBtn.layer.borderWidth = 2
        addGoalBtn.layer.borderColor = UIColor.black.cgColor
        addGoalBtn.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
