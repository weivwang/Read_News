//
//  CollectTableViewController.swift
//  READNEWS
//
//  Created by 王威卫 on 2021/6/11.
//

import UIKit

class CollectTableViewController: UITableViewController {

    var queryResult:[[String:AnyObject]]?
    var searchcontroller :UISearchController!
    let resultViewController = SearchResultTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM newstable;")
        sqlite.closeDB()
        initSearch()
    
        setRefreshView()
        loadMore()
    }
    
    func initSearch() {
       
        searchcontroller = UISearchController(searchResultsController: resultViewController)
        let searchBar = searchcontroller.searchBar
        searchBar.placeholder = "输入新闻标题"
        searchBar.sizeToFit()
        searchBar.scopeButtonTitles = ["标题"]
        tableView.tableHeaderView = searchBar
        searchcontroller.searchResultsUpdater = resultViewController
        self.definesPresentationContext = true
    }
    
    func setMoreView() {
        let loadMoreView = UIView(frame:CGRect(x:0,y:self.tableView.contentSize.height,width: self.tableView.bounds.size.width,height: 60))
        loadMoreView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        loadMoreView.backgroundColor = self.tableView.backgroundColor
        
        //中间的环形进度条
        let indicator = UIActivityIndicatorView()
        let indicatorX = self.view.frame.width/2-indicator.frame.width/2
        let indicatorY = loadMoreView.frame.size.height/2-indicator.frame.height/2
        indicator.frame = CGRect(x:indicatorX, y:indicatorY, width:indicator.frame.width, height:indicator.frame.height)
        indicator.startAnimating()
        
        loadMoreView.addSubview(indicator)
        self.tableView.tableFooterView = loadMoreView
        
    }
    
    func setRefreshView(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.refreshData()
    }
    
    @objc func refreshData(){
        NewsManager.shared.refresh{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func loadMore(){
           print("加载新数据！")
           NewsManager.shared.fetchMore {
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }
    


    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return 0}
        queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM newstable;")
        sqlite.closeDB()
        return queryResult!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath)
        
        cell.textLabel?.text = queryResult?[indexPath.row]["title"]! as? String
        resultViewController.allNewsTitle.append(cell.textLabel?.text ?? " ")
        cell.detailTextLabel?.text = queryResult?[indexPath.row]["passtime"]! as? String
        let iurl = URL(string: (queryResult?[indexPath.row]["url"]! as? String)!)
        let data = try! Data(contentsOf: iurl!)
        cell.imageView?.image = UIImage(data: data)

    
        return cell
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? CollectDetailViewController
        {
            let sqlite = SQLiteManager.sharedInstance
            if !sqlite.openDB() {return}
            queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM newstable;")
            sqlite.closeDB()
            print(queryResult ?? " ")
            
            if let indexPath = tableView.indexPathForSelectedRow{
                dest.newstitle = (queryResult?[indexPath.row]["title"]! as? String)!
                //print(queryResult?[indexPath.row]["title"]! as? String)
                print((queryResult?[indexPath.row]["title"]! as? String)!)
                //print(dest.title)
                dest.newspath = (queryResult?[indexPath.row]["url"]! as? String)!
            dest.newspasstime = (queryResult?[indexPath.row]["passtime"]! as? String)!
            dest.newsimage = (queryResult?[indexPath.row]["image"]! as? String)!
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
