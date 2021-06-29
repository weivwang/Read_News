//
//  NewsDAL.swift
//  READNEWS
//
//  Created by 王威卫 on 2021/6/11.
//

import Foundation
class NewsDAL{
    static func initDB(){
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        //这里存image用的是TEXT类型，因为News类中的image是string类型，实际上是一个url
        //在tableview加载图片时，使用的是如下方法：
        //let iurl = URL(string: NewsManager.shared.news[indexPath.row].image)
        //let data = try! Data(contentsOf: iurl!)
        //cell.imageView?.image = UIImage(data: data)
        
        let createNews = "CREATE TABLE IF NOT EXISTS newstable('title' TEXT NOT NULL PRIMARY KEY,'url' TEXT,'passtime' TEXT,'image' TEXT);"
        let result = sqlite.exeNoneQuery(sql: createNews)
        print("初始化结果：\(result)")
        return
    }
    static func saveNews(title:String,url:String,passtime:String,image:String){
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}
        let sql = "INSERT OR REPLACE INTO newstable(title,url,passtime,image) VALUES('\(title)','\(url)','\(passtime)','\(image)'); "
        let result =  sqlite.execQuerySQL(sql: sql)
        print("添加结果：\(String(describing: result))")
        sqlite.closeDB()
        return
    }
    static func deleteNews(title:String){
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        let sql = "DELETE FROM newstable WHERE title = '\(title)';"
        let result = sqlite.exeNoneQuery(sql: sql)
        print("删除结果：\(result)")
        sqlite.closeDB()
        return
    }
}
