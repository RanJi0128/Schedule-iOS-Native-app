//
//  ManageController.swift
//  scheduling
//
//  Created by Marten on 7/8/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import UIKit
import CoreData


class ManageController
{
    class func addData(tableName : String, data : [Int:String])
    {
        let entity = NSEntityDescription.insertNewObject(forEntityName: tableName, into: Constant.context)
        
        for (key) in data.keys {
            
            entity.setValue(data[key],forKey: "name");
            entity.setValue(key,forKey: "key");
        }
        do
        {
            try Constant.context.save()
        }
        catch
        {
            print("Catch block.")
        }
        
    }
    class func getData(tableName : String) -> [Int:String]? {
        
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        var data: [NSManagedObject] = []
        var getData: [Int:String]?
        
        do {
            data = try Constant.context.fetch(fetchRequest) as! [NSManagedObject]
            if (data.count == 0) {
                return nil
            }
            for i in 0..<data.count {
                
                let key : Int = data[i].primitiveValue(forKey: "key") as! Int
                
                getData![key]=data[i].primitiveValue(forKey: "name") as? String
                
                
            }
            
            return getData
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

