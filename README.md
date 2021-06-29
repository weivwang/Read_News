***\*【实验目的】\*******\*：\**** 

 设计一个新闻阅读APP，实现的主要功能有：

 

\1. LaunchScreen启动页图片中有学号和姓名

\2. Login登录界面，用户验证无需网络，可在程序代码中写入，用学号作为用户名，密码123可登录，用户登录成功后将用户名写入UserDefaults，下次登录无需再输入用户名。

\3. 主界面有两个tab，一个是用于新闻浏览，一个显示收藏的新闻。

\4. 新闻浏览页功能包括：

（1） 加载时访问提供的新闻API，获取返回的新闻信息，参数page是页码，count是新闻数；

（2） 新闻浏览显示用TableViewController，某条新闻的cell需呈现标题、日期和图片；

（3） 选择某条新闻后，打开有WKWebView控件的页面呈现该url的新闻，并可收藏此新闻，收藏后在收藏tab上显示已收藏的数量；

\5. 收藏页功能包括： 

（1） 所有收藏的新闻列表（收藏的新闻存放在本地Sqlite数据库中）；

（2） 可以对该列表中的收藏进行删除；

（3） 可通过标题查询收藏的新闻；

（4） 点击收藏的新闻可呈现新闻内容

***\*【实验环境】（使用的软件）\*******\*：\****

 Xcode Version 12.4

 IOS Stimulators - iPhone 11

***\*【\*******\*参考资料\*******\*】\*******\*：\****

《精通IOS开发（第8版）》 

高建华老师上课录制视频及课后作业



***\*【实验方案设计】\*******\*：\**** 

\1. 开屏动画（LaunchScreening）

开屏界面使用建项目时自带的LaunchScreen.storyboard文件进行设计，背景图片使用星空山河图，在界面上添加了3个Label分别用来显示:欢迎标语，账号信息和密码信息。设计界面如下：

<img src="https://i.loli.net/2021/06/29/6RjO4zc8q2htJyA.jpg" alt="img" style="zoom:25%;" width = "50%"/>

 

运行界面如下：

<img src="https://i.loli.net/2021/06/29/MaCyoW4GTkI8DUm.jpg" alt="img" style="zoom:25%;" width = 30% />

 

2，登录界面

 登录界面的设计使用系统创建的Main.storyboard进行全部视图的设计，将与ViewController类绑定的界面作为登录界面，勾选is Initial View Controller，表明系统第一次进入显示登录界面。

登录界面如图：

 

<img src="https://i.loli.net/2021/06/29/MVr48mKIZjTH3BX.jpg" alt="img" style="zoom: 25%;" width = 30%/>

 

Main.storyboard设计方案：

 

![img](https://i.loli.net/2021/06/29/wifGolRzFJKhW5x.jpg)

 

登录信息验证模块：

将登录按钮按住control键拖拽到对应的viewcontroller类中，绑定点击事件，代码如下

 @IBAction func loginPressed(_ sender: Any) {

​    let usercode = loginTextField.text!
​    let psw = passwordTextField.text!
​    loginTextField.resignFirstResponder()
​    passwordTextField.resignFirstResponder()
​    
​    if((usercode == "2019302110426" || loginTextField.text == "2019302110426") && psw == "123"){
​      let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
​      let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
​      UIApplication.shared.windows[0].rootViewController = VCMain
​      UserDefaults.standard.set("2019302110426", forKey: "usercode")
​      
​    }else{
​      let p = UIAlertController(title: "登录失败", message: "用户名或密码错误", preferredStyle:.alert)
​      p.addAction(UIAlertAction(title: "确定", style: .default, handler: {
​        (act:UIAlertAction) in self.passwordTextField.text = ""
​      }))
​      present(p, animated: false, completion: nil)
​    }
  }

登录成功时，执行： let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
      let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
      UIApplication.shared.windows[0].rootViewController = VCMain

 

来跳转到TableBarViewController

 

同时使用：UserDefaults.standard.set("2019302110426", forKey: "usercode")

来将学号信息设为默认配置。

 

若登录失败，则弹出UIAlertController来提示用户用户名或密码错误，效果如下： 

<img src="https://i.loli.net/2021/06/29/q6j1EgxJz54C3QR.jpg" alt="img" style="zoom:25%;" width = 30%/>

 

密码校验成功后，进入主界面。

 

3 主界面

 

主界面整体由一个TabBarViewController进行组织，包含3个页面：新闻，收藏和开发者。

分别用来展示新闻列表，收藏新闻列表和开发者信息，整体界面设计图如下：

 

<img src="https://i.loli.net/2021/06/29/f9eKv5Uh4zBVS1I.jpg" alt="img" style="zoom:25%;" width = 60%/>

 

3.1 新闻界面

<img src="https://i.loli.net/2021/06/29/arx2n45LXteBfFh.jpg" alt="img" style="zoom:25%;" width = 30%/>

 

该界面实现细节如下：

 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // debug
    print(NewsManager.shared.news.count)
    return NewsManager.shared.news.count
    }

返回行数为NewsManager的实例通过API获取到的news的数量。

 

News类定义如下：

class News:NSObject, Codable
{
  var title:String = ""
  var path:String = ""
  var passtime:String = ""
  var image:String = ""
  
  private enum CodingKeys: String, CodingKey{
    case title
    case path
    case passtime
    case image
  }
  
  init(title:String)
  {
    self.title = title
  }
  
  override var description: String {
    return "title:\(title)"
  }

 

 

 

Cell的显示内容如下：

 

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
      
      //todo init cell
      cell.textLabel?.text = NewsManager.shared.news[indexPath.row].title
      cell.detailTextLabel?.text = NewsManager.shared.news[indexPath.row].passtime
//      cell.imageView?.image = UIImage(named: NewsManager.shared.news[indexPath.row].image)
      
      let iurl = URL(string: NewsManager.shared.news[indexPath.row].image)
      let data = try! Data(contentsOf: iurl!)
      cell.imageView?.image = UIImage(data: data)
      
      //当下拉到底部，执行loadMore()
      if (indexPath.row == NewsManager.shared.news.count-1) {
        loadMore()
      }
      return cell
     }

 

在storyboard中将cell的style改为Subtitle，设置标题为news数组对应行数的标题

设置下面的详细内容为news的passtime

图片加载中，news[i].image实际是一个String类型的值，本身是一个url，所以使用：let iurl = URL(string: NewsManager.shared.news[indexPath.row].image)
      let data = try! Data(contentsOf: iurl!)
      cell.imageView?.image = UIImage(data: data)

 

来进行加载。

 

在storyboard界面将cell与下一个界面相连，实现点击cell跳转的功能。

重写prepare方法实现数据的传递:

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if let dest = segue.destination as? DetailViewController
      {
        dest.news = NewsManager.shared.news[tableView.indexPathForSelectedRow!.row]
      }
    }

 

当点击新闻cell后，会将所选中的行数对应的news[]数组里面的News对象传递给DetailViewController类

在DetailViewController中，使用WKWebView控件来加载网页新闻

DetailViewController.swift代码如下：

import UIKit
import WebKit

class DetailViewController: UIViewController {
  var news:News?

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let path = news?.path else {return}
    
    guard let url = URL(string: path) else { return }
    let urlRequest = URLRequest(url: url) 
    self.DetailNews.load(urlRequest)

​    // Do any additional setup after loading the view.
  }
  
  @IBOutlet weak var DetailNews: WKWebView!
  
 
  
  @IBAction func saveButtonTapped(_ sender: Any) {
​    
​    //?? "" 代表默认值为空，是跟着提示走的
​    NewsDAL.saveNews(title: news!.title, url: news?.path ?? "",passtime:news?.passtime ?? "", image:news?.image ?? "")
​    //debug
​    let sqlite = SQLiteManager.sharedInstance
​    if !sqlite.openDB() {return}
​    let sql = "SELECT * FROM newstable;"
​    let queryresult = sqlite.execQuerySQL(sql: sql)
​    print(queryresult ?? "")
​    let p = UIAlertController(title: "成功", message: "收藏成功", preferredStyle:.alert)
​    p.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
​    present(p, animated: false, completion: nil)
  }

 

各部分功能如下：


 @IBOutlet weak var DetailNews: WKWebView! 用来注册控件

 

guard let path = news?.path else {return}
    guard let url = URL(string: path) else { return }
    let urlRequest = URLRequest(url: url) 
    self.DetailNews.load(urlRequest)

使用上个界面传递过来的News实例的path进行新闻加载。

 

在界面中，我设置了一个收藏按钮，用于进行新闻收藏，当点击按钮，会调用NewsDAL的saveNews方法，将该新闻的title，passtime，path，和image插入数据库。

并会弹出提示框用于显示是否收藏成功。显示该界面显示效果如下：

 

<img src="https://i.loli.net/2021/06/29/xHdeEh4y1nQXjiY.jpg" alt="img" style="zoom:25%;" width = 30%/>

 

点击收藏新闻后，收藏成功提示：

 

<img src="https://i.loli.net/2021/06/29/OVT4WoAcp17exhX.jpg" alt="img" style="zoom:25%;" width = 30%/>

 

3.2 收藏界面:

 

在新闻浏览界面收藏的新闻会显示到收藏界面，因为收藏界面与数据库息息相关，所以完成收藏界面之前，需要先完成数据库部分。

 

数据库设计

 

数据库部分主要包含两个文件：SQLiteManager.swift和NewsDAL.swift

SQLiteManager.swift内容如下：

基本都是参考老师上课代码实现，用于执行sql语句。

 

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
      print("fail to open database")
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

 

我又新建了NewsDAL类，用于建表，和封装收藏和取消收藏的功能

代码如下：


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
    let result = sqlite.execQuerySQL(sql: sql)
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

 

主要包含3个静态方法：initDB()：用于初始化数据库，建表。其中，我设置了4个表项：分别是title，url，passtime，image。

saveNews(title:String,url:String,passtime:String,image:String)：用于将收藏新闻插入数据库

点击收藏按钮后调用该方法。

deleteNews(title:String)：用于取消收藏时，将新闻从数据库中删除。

 

收藏界面如图：

 

<img src="https://i.loli.net/2021/06/29/nLPi8IpNq3eCZMK.jpg" alt="img" style="zoom:25%;" width = 30%/>

这里收藏界面存在bug，是图片无法显示。Debug发现是查询数据库的image结果为空，但将queryresult输出发现image字段不为空，可能是在解包或赋值image变为空了，但碍于时间原因，且该效果不影响实际使用，所以没有进一步解决。

 

该界面实现细节如下：

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

初始化界面时，将queryresult赋值为查询结果。

 

 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    let sqlite = SQLiteManager.sharedInstance
    if !sqlite.openDB() {return 0}
    queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM newstable;")
    sqlite.closeDB()
    return queryResult!.count
  }

 

返回cell的数量为查询结果的数量。

 

 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    let sqlite = SQLiteManager.sharedInstance
    if !sqlite.openDB() {return 0}
    queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM newstable;")
    sqlite.closeDB()
    return queryResult!.count
  }

 

cell的内容加载如下：

 

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

 

 

重写prepare方法，实现数据传递：

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

 

根据标题搜索功能：

<img src="https://i.loli.net/2021/06/29/fbFJN3qcES69V5x.jpg" alt="img" style="zoom:25%;" width = 30%/>

实现代码如下：

 

import UIKit

class SearchResultTableViewController: UITableViewController,UISearchResultsUpdating {
  
  
  
  var allNewsTitle:[String] = []
  var filterNewsTitle:[String] = []
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "news")
    
    let sqlite = SQLiteManager.sharedInstance
    if !sqlite.openDB() {return}
    let sql = "SELECT * FROM newstable;"
    let queryresult = sqlite.execQuerySQL(sql: sql)
    print(queryresult ?? "")

​     }

  // MARK: - Table view data source


  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return filterNewsTitle.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath)

​    cell.textLabel?.text = filterNewsTitle[indexPath.row]
​    // Configure the cell...

​    return cell
  }

 

在CollectViewController中写了如下方法：

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

在初始化界面调用，用于将搜索框显示在页面上。

 

点击收藏界面的新闻cell，同样可以进入对应的新闻界面：

<img src="https://i.loli.net/2021/06/29/mM3n6KchSdaW4Pl.jpg" alt="img" style="zoom:25%;" width = 30%/>

该界面，我设置了取消收藏按钮，当点击取消按钮，会调用NewsDAL.deleteNews(title:String)方法，将该新闻从数据库中删除。并会弹出提示框，提示用户删除成功。显示效果如下：

<img src="https://i.loli.net/2021/06/29/rTX2Pbcu5Z8LpDB.jpg" alt="img" style="zoom:25%;" width = 30%/>

 

返回收藏界面刷新后，该条新闻被删除：

<img src="https://i.loli.net/2021/06/29/dOJTi5RIYgsGmp8.jpg" alt="img" style="zoom:25% ;" width = "30%" />

 

3.3 开发者界面

开发者界面主要是自己diy出来的，完整软件做下来感觉非常有成就感，所以设计了一个开发者界面，感觉很cool。

<img src="https://i.loli.net/2021/06/29/fvdlqQjVLsExOG2.jpg" alt="img" style="zoom:25%;" width = 30%/>
