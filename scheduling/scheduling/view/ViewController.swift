//
//  ViewController.swift
//  scheduling
//
//  Created by Marten on 6/19/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit

var db: OpaquePointer?

class ViewController: UIViewController {

    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var addGoalLabel: UILabel!
    @IBOutlet weak var addActionLabel: UILabel!
    @IBOutlet weak var goalAllViewLabel: UILabel!
    @IBOutlet weak var contactViewLabel: UILabel!
    @IBOutlet weak var groupViewLabel: UILabel!
    @IBOutlet weak var accountViewLabel: UILabel!
    @IBOutlet weak var settingViewLabel: UILabel!
    @IBOutlet weak var mainTilte: UILabel!
    
    
    @IBOutlet var backGroundView: UIView!
    
    var viewTitle : String = "Hello Mitta"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backGroundView.layer.borderWidth = 3
        backGroundView.layer.borderColor = UIColor.black.cgColor
        
        mainTilte.text = viewTitle
        var dbPath : String = nibBundle?.resourcePath ?? ""
        dbPath = (dbPath as NSString).appendingPathComponent("db.sqlite3")
        
        db = openDatabase(dbPath: dbPath) //"/Users/marten/Documents/scheduling/scheduling/model/db/db.sqlite3"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        var location = touch.location(in: homeLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"HomeViewController")
        }
        location = touch.location(in: addGoalLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"AddGoalViewController")
        }
        location = touch.location(in: addActionLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"AddActionViewController")
        }
        location = touch.location(in: goalAllViewLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"GoalAllViewController")
        }
        location = touch.location(in: contactViewLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"ContactViewController")
        }
        location = touch.location(in: groupViewLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"GroupViewController")
        }
        location = touch.location(in: accountViewLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"AccountViewController")
        }
        location = touch.location(in: settingViewLabel)
        if 0 < location.x && 100 > location.x && 0 < location.y && 30 > location.y
        {
            
            handleTap(id:"SettingViewController")
        }
        
    }
   
    
    func handleTap(id : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id) 
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
}

