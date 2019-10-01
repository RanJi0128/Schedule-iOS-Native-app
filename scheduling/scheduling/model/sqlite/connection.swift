//
//  connection.swift
//  scheduling
//
//  Created by Marten on 7/8/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import SQLite3
import Foundation
import SQLite3

func openDatabase(dbPath :String) -> OpaquePointer? {
    
    var db: OpaquePointer? = nil
    
    // BOOL success = [fileMgr fileExistsAtPath:dbPath];
  //  print("cal------>"+dbPath)
    //let dbPath :String = "/Users/marten/Documents/scheduling/scheduling/model/db/db.sqlite3"
    
    if sqlite3_open(dbPath, &db) == SQLITE_OK {
        print("Successfully opened connection to database at \(dbPath)")
        return db
    } else {
        print("Unable to open database. Verify that you created the directory described " +
            "in the Getting Started section.")
        return nil
    }
    
}
func insert_sql(queryString : String,insertData : [NSString]) -> Bool{
    
    var queryStatement: OpaquePointer? = nil

    if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
        
    for i in 0..<insertData.count
    {    
        sqlite3_bind_text(queryStatement, Int32(i+1), insertData[i].utf8String, -1, nil)
    }
        
        
    if sqlite3_step(queryStatement) == SQLITE_DONE {

            print("Successfully inserted row.")
            return true

        } else {
        
            print("Could not insert row.")
        }
    } else {
        print("INSERT statement could not be prepared.")
    }
    sqlite3_finalize(queryStatement)
    return false
}

var queryResult = [[String]]()

func get_sql(queryString : String) -> Bool{
    
    var queryStatement: OpaquePointer? = nil
    
    queryResult.removeAll()
    
    if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {

            var resultCount : Int = 0
            var tempStr : [String] = []
        
            while(sqlite3_step(queryStatement) == SQLITE_ROW)
            {
                tempStr.removeAll()
                for i in 0..<sqlite3_column_count(queryStatement)
                {
                    tempStr.append(String(cString: sqlite3_column_text(queryStatement, i)))
                    
                }
                queryResult.append(tempStr)
                
                resultCount+=1
            }
        if resultCount == 0 {
            
            print("Query returned no results")
    
        }
        else {return true}
        
    } else {
        print("SELECT statement could not be prepared")
    }
    
    sqlite3_finalize(queryStatement)
    
    return false
}

func delete_sql(queryString : String) {
    
    var deleteStatement: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, queryString, -1, &deleteStatement, nil) == SQLITE_OK {
        
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            
            print("Successfully deleted row.")
            
        } else {
            
            print("Could not delete row.")
        }
    } else {
        
        print("DELETE statement could not be prepared")
    }
    
    sqlite3_finalize(deleteStatement)
}



