//
//  CheckBoxController.swift
//  scheduling
//
//  Created by Marten on 6/30/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
 
    // Images
    var checkedImage = UIImage(named: "review")
    var uncheckedImage = UIImage(named: "none-review")
    // Bool property
   
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            
            isChecked = !isChecked
        }
    }
}
