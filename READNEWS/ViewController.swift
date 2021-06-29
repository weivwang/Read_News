//
//  ViewController.swift
//  READNEWS
//
//  Created by 王威卫 on 2021/5/19.
//

import UIKit




class ViewController: UIViewController {
   
    
    override func viewDidLoad() {
        
        loginTextField.text = UserDefaults.standard.string(forKey: "usercode")
        super.viewDidLoad()
        NewsDAL.initDB()
//        CGRect rc = [[UIScreen mainScreen] bounds]
//        imageView.frame = rc
//        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBAction func loginPressed(_ sender: Any) {

        let usercode = loginTextField.text!
        let psw = passwordTextField.text!
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if((usercode == "2019302110426" || loginTextField.text == "2019302110426") && psw == "123"){
            let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
            UIApplication.shared.windows[0].rootViewController = VCMain
            UserDefaults.standard.set("2019302110426", forKey: "usercode")
            
        }else{
            let p = UIAlertController(title: "登录失败", message: "用户名或密码错误", preferredStyle:.alert)
            p.addAction(UIAlertAction(title: "确定", style: .default, handler: {
                (act:UIAlertAction) in self.passwordTextField.text = ""
            }))
            present(p, animated: false, completion: nil)
        }
    }
    
}

