//
//  RegisterViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/14/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class RegisterViewController: BaseViewController {
    
    
    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtRPassword: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    
    var successLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.view.transform = CGAffineTransformMakeScale(-1, 1)
        //        lblRememberMe.transform = CGAffineTransformMakeScale(-1, 1)
        // Do any additional setup after loading the view.
        
        //MARK: - Login String
        
        
        
        txtUserName.placeholder = "Email".localized()
        txtPassword.placeholder = "Password".localized()
        btnRegister.setTitle("Register".localized(), forState: .Normal)
        txtPhone.placeholder = "Tell".localized()
        txtRPassword.placeholder = "RepeatPass".localized()
        btnLogin.setTitle("Login".localized(), forState: .Normal)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
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
            
            self.bottomConstraint.constant = 45
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Buttons Tap
    
    @IBAction func btnRegisterTap(sender: AnyObject) {
        
       // sendRegisterRequest(txtUserName.text!, password:txtPassword.text!, pushToken: PushToken)
        
    }
    
    
    
    @IBAction func btnLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK:- Login Service
    
    func sendRegisterRequest(email:String , password:String , pushToken:String) {
        /**
         Login
         POST http://sabadbannewstest.sefryek.com/api/v1/auth/register
         */
        btnRegister.enabled = false
        let progress:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progress.frame = CGRectMake(btnRegister.bounds.maxX - 30, btnRegister.bounds.maxY - 33, 20, 20)
        progress.startAnimating()
        btnRegister.addSubview(progress)
        progress.hidesWhenStopped = true
        let url = AppNewsURL + URLS["register"]!
        
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
                        if login.errorCode == 100 {
                            LoginToken = login.result.apiToken
                            self.successLogin = true
                            LogedInUserName = email
                           self.dismissViewControllerAnimated(true, completion: nil)
                            
                            
                        }
                        
                    }
                    self.btnRegister.enabled = true
                    progress.stopAnimating()
                case .Failure(let error):
                    debugPrint(error)
                    self.btnRegister.enabled = true
                    progress.stopAnimating()
                }
                
        }
    }
    
    
    
    
}