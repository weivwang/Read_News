//
//  CollectDetailViewController.swift
//  READNEWS
//
//  Created by 王威卫 on 2021/6/11.
//

import UIKit
import WebKit

class CollectDetailViewController: UIViewController {
    var newstitle:String = ""
    var newspath:String = ""
    var newspasstime:String = ""
    var newsimage:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: newspath) else { return  }
        let urlRequest = URLRequest(url: url)
        self.collectDetailNews.load(urlRequest)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var collectDetailNews: WKWebView!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        NewsDAL.deleteNews(title: newstitle)
        //debug
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        let sql = "SELECT * FROM newstable;"
        let queryresult = sqlite.execQuerySQL(sql: sql)
        print(queryresult ?? "")
        let p = UIAlertController(title: "成功", message: "取消成功", preferredStyle:.alert)
        p.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(p, animated: false, completion: nil)
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
