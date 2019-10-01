//
//  GroupViewController.swift
//  scheduling
//
//  Created by Marten on 7/4/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var textInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        textInput.layer.borderWidth = 1
        textInput.layer.borderColor = UIColor.black.cgColor
        textInput.layer.cornerRadius = 5
        
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = UIColor.black.cgColor
        submitBtn.layer.cornerRadius = 10
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
