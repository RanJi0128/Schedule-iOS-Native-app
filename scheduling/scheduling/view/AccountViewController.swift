//
//  AccountViewController.swift
//  scheduling
//
//  Created by Marten on 7/23/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var editUsernameBtn: UIButton!
    @IBOutlet weak var changePwdBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var rewardsLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        
        upgradeBtn.layer.borderWidth = 1
        upgradeBtn.layer.borderColor = UIColor.black.cgColor
        upgradeBtn.layer.cornerRadius = 10
        
        editUsernameBtn.layer.borderWidth = 1
        editUsernameBtn.layer.borderColor = UIColor.black.cgColor
        editUsernameBtn.layer.cornerRadius = 10
        
        changePwdBtn.layer.borderWidth = 1
        changePwdBtn.layer.borderColor = UIColor.black.cgColor
        changePwdBtn.layer.cornerRadius = 10
        
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor = UIColor.black.cgColor
        deleteBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
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
