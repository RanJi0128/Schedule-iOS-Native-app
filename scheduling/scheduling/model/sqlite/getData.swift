//
//  getData.swift
//  scheduling
//
//  Created by Marten on 7/8/19.
//  Copyright © 2019 Marten. All rights reserved.
//

import SQLite3

func getText(queryStatement: OpaquePointer?,colNum : Int32) -> String {
    
    let queryResult = sqlite3_column_text(queryStatement, colNum)
    
    return String(cString: queryResult!)
}


func getInt(queryStatement: OpaquePointer?,colNum : Int32) -> Int32 {
    
    let queryResult = sqlite3_column_int(queryStatement, colNum)
    
    return queryResult
}
