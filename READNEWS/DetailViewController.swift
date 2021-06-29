//
//  DetailViewController.swift
//  READNEWS
//
//  Created by 王威卫 on 2021/5/26.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var news:News?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = news?.path else {return}
        
        guard let url = URL(string: path) else { return  }
        let urlRequest = URLRequest(url: url) 
        self.DetailNews.load(urlRequest)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var DetailNews: WKWebView!
    
  
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        //?? "" 代表默认值为空，是跟着提示走的
        NewsDAL.saveNews(title: news!.title, url: news?.path ?? "",passtime:news?.passtime ?? "", image:news?.image ?? "")
        //debug
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        let sql = "SELECT * FROM newstable;"
        let queryresult = sqlite.execQuerySQL(sql: sql)
        print(queryresult ?? "")
        let p = UIAlertController(title: "成功", message: "收藏成功", preferredStyle:.alert)
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
