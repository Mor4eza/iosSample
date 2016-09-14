//
//  LoginViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/11/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: BaseViewController {
    
    @IBOutlet weak var lblRememberMe: UILabel!
    
    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var chkRemember: UISwitch!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var btnForgetPass: UIButton!
    var successLogin = false
    var defaults  = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.view.transform = CGAffineTransformMakeScale(-1, 1)
        //        lblRememberMe.transform = CGAffineTransformMakeScale(-1, 1)
        // Do any additional setup after loading the view.
        
        //MARK: - Login String
        
        
        lblRememberMe.text = "RememberMe".localized()
        btnLogin.setTitle("Login".localized(), forState: .Normal)
        txtUserName.placeholder = "Email".localized()
        txtPassword.placeholder = "Password".localized()
        btnRegister.setTitle("Register".localized(), forState: .Normal)
        btnForgetPass.setTitle("ForgetPassword".localized(), forState: .Normal)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        debugPrint(defaults.stringForKey("UserName"))
        if defaults.stringForKey("UserName") != nil {
            chkRemember.setOn(true, animated: true)
        }
        
        if chkRemember.on == true {
            txtUserName.text = defaults.stringForKey("UserName")
            txtPassword.text = defaults.stringForKey("Password")
        }
        
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            UIView.animateWithDuration(1, delay: 0, options: .CurveEaseIn, animations: {
                
                self.bottomConstraint.constant = keyboardSize.height
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseIn, animations: {
            
            self.bottomConstraint.constant = 100
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Buttons Tap
    
    @IBAction func btnLoginTap(sender: AnyObject) {
        
        if isSimulator {
            sendLoginRequest(txtUserName.text!, password:txtPassword.text!, pushToken: "IOS_RUNNING_FROM_SIMULATOR")
        }else {
            sendLoginRequest(txtUserName.text!, password:txtPassword.text!, pushToken: PushToken)
        }
        
    }
    
    @IBAction func btnForgetTap(sender: AnyObject) {
        
    }
    
    
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        if identifier == "loginSegue" {
            if successLogin {
                return true
            }else {
                return false
            }
            
        }
        return true
    }
    
    
    //MARK:- Login Service
    
    func sendLoginRequest(email:String , password:String , pushToken:String) {
        /**
         Login
         POST http://sabadbannewstest.sefryek.com/api/v1/auth/login
         */
        btnLogin.enabled = false
        let progress:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progress.frame = CGRectMake(btnLogin.bounds.maxX - 30, btnLogin.bounds.maxY - 33, 20, 20)
        progress.startAnimating()
        btnLogin.addSubview(progress)
        progress.hidesWhenStopped = true
        let url = AppNewsURL + URLS["login"]!
        
        // JSON Body
        let body = [
            "email": email,
            "device_token": pushToken,
            "password": password
        ]
        
        // Fetch Request
        Alamofire.request(.POST, url, headers: ServicesHeaders, parameters: body, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(UserManagementModel<LoginResponse>.self) { response in
                
                switch response.result {
                case .Success(let login):
                    
                    if login.result != nil {
                        if login.errorCode == 200 {
                            LoginToken = login.result.apiToken
                            self.successLogin = true
                            LogedInUserName = email
                            self.performSegueWithIdentifier("loginSegue", sender: nil)
                            
                            if self.chkRemember.on == true {
                                self.defaults.setValue(email, forKey: "UserName")
                                self.defaults.setValue(password, forKey: "Password")
                            }else {
                                self.defaults.setValue(nil, forKey: "UserName")
                                self.defaults.setValue(nil, forKey: "Password")
                            }
                        }
                        
                    }
                    self.btnLogin.enabled = true
                    progress.stopAnimating()
                case .Failure(let error):
                    debugPrint(error)
                    self.btnLogin.enabled = true
                    progress.stopAnimating()
                }
                
        }
    }
    
}