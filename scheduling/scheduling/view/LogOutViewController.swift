//
//  LogOutViewController.swift
//  scheduling
//
//  Created by Marten on 6/24/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit
import Firebase

class LogOutViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var iconClick_1 = true

    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.delegate=self as UITextFieldDelegate
        username.delegate=self as UITextFieldDelegate
        password.delegate=self as UITextFieldDelegate
        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func signUpAction(_ sender: Any) {
        if password.text == nil || username.text == nil {
            let alertController = UIAlertController(title: "Username or Password Incorrect", message: "Please re-type Username or Password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func iconAction_1(_ sender: Any) {
        if(iconClick_1 == true) {
            password.isSecureTextEntry = false
            (sender as AnyObject).setImage(UIImage(named: "design_ic_visibility"), for: UIControl.State.normal)
        } else {
            password.isSecureTextEntry = true
            (sender as AnyObject).setImage(UIImage(named: "design_ic_visibility_off"), for: UIControl.State.normal)
        }
        
        iconClick_1 = !iconClick_1
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
extension LogOutViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        self.updateSaveButtonState()
        
    }
}
