//
//  SQLiteManager.swift
//  READNEWS
//
//  Created by 王威卫 on 2021/6/11.
//

import Foundation
import Foundation

class SQLiteManager:NSObject
{
    private var a:Int = 0
    private var dbPath:String!
    private var database:OpaquePointer? = nil
    
    static var sharedInstance:SQLiteManager
    {
        return SQLiteManager()
    }
    
    override init() {
        super.init()
        let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        dbPath = dirPath.appendingPathComponent("app.sqlite").path
        
    }
    
    //open database
    
    func openDB() -> Bool {
        let result = sqlite3_open(dbPath, &database)
        if result != SQLITE_OK
        {
            print("fail to open  database")
            return false
        }
        return true
    }
    
    //close database
    func closeDB(){
        sqlite3_close(database)
    }
    
    //execute the statement:select
    func execQuerySQL(sql:String)->[[String:AnyObject]]?{
        let cSql = sql.cString(using: String.Encoding.utf8)!
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, cSql, -1, &statement, nil) != SQLITE_OK{
            sqlite3_finalize(statement)
            print("执行\(sql)错误\n")
            let errmsg = sqlite3_errmsg(database)
            if errmsg != nil{
                print(errmsg!)
            }
            
            return nil
        }
        
        var rows = [[String:AnyObject]]()
        
        while sqlite3_step(statement) == SQLITE_ROW{
            rows.append(record(stmt:statement!))
        }
        
        sqlite3_finalize(statement)
        
        return rows
    }
    
    private func record(stmt:OpaquePointer)->[String:AnyObject]{
        var row = [String:AnyObject]()
        
        for col in 0 ..< sqlite3_column_count(stmt){
            let cName = sqlite3_column_name(stmt, col)
            let name = String(cString:cName!,encoding: String.Encoding.utf8)
            
            var value:AnyObject?
            
            switch (sqlite3_column_type(stmt, col)) {
            case SQLITE_FLOAT:
                value = sqlite3_column_double(stmt, col) as AnyObject
            case SQLITE_INTEGER:
                value = Int(sqlite3_column_int(stmt, col)) as AnyObject
            case SQLITE_TEXT:
                let cText = sqlite3_column_text(stmt, col)
                value = String.init(cString: cText!) as AnyObject
            case SQLITE_NULL:
                value = NSNull()
            default:
                a+=1
            }
            row[name!] = value ?? NSNull()
        }
        return row
    }
    
    //execute the statement:create,insert,update,delete
    func exeNoneQuery(sql:String) -> Bool{
        
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let cSql = sql.cString(using: String.Encoding.utf8)
        
        if sqlite3_exec(database, cSql, nil, nil, &errMsg) == SQLITE_OK{
            return true
        }
        let msg = String.init(cString: errMsg!)
        print(msg)
        return false
    }
}
