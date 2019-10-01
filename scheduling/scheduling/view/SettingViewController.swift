//
//  SettingViewController.swift
//  scheduling
//
//  Created by Marten on 7/23/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var switch_1: UISwitch!
    @IBOutlet weak var switch_2: UISwitch!
    @IBOutlet weak var switch_3: UISwitch!
    @IBOutlet weak var switch_4: UISwitch!
    @IBOutlet weak var switch_5: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        switch_1.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switch_2.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switch_3.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switch_4.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switch_5.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
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
