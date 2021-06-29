//
//  TableViewController.swift
//  READNEWS
//
//  Created by 王威卫 on 2021/5/19.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setMoreView()
        setRefreshView()
        loadMore()
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
            // todo
        print(NewsManager.shared.news.count)
        return NewsManager.shared.news.count
        }

         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            
            //todo init cell
            cell.textLabel?.text = NewsManager.shared.news[indexPath.row].title
            cell.detailTextLabel?.text = NewsManager.shared.news[indexPath.row].passtime
//            cell.imageView?.image = UIImage(named:  NewsManager.shared.news[indexPath.row].image)
            
            let iurl = URL(string: NewsManager.shared.news[indexPath.row].image)
            let data = try! Data(contentsOf: iurl!)
            cell.imageView?.image = UIImage(data: data)
            
            //当下拉到底部，执行loadMore()
            if (indexPath.row == NewsManager.shared.news.count-1) {
                loadMore()
            }
            
            return cell
         }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if let dest = segue.destination as? DetailViewController
            {
                dest.news = NewsManager.shared.news[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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


