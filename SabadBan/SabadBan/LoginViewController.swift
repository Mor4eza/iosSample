//
//  LoginViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/11/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
import FCAlertView
class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
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
        txtPassword.delegate = self
        txtUserName.delegate = self
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == txtUserName {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            textField.resignFirstResponder()
            beginLoginSequence()
        }
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Buttons Tap
    
    @IBAction func btnLoginTap(sender: AnyObject) {
        beginLoginSequence()
    }
    
    @IBAction func btnForgetTap(sender: AnyObject) {
        
    }
    
    func showAlert(message : String) {
        
        
        let alert = FCAlertView()
        alert.makeAlertTypeCaution()
        alert.colorScheme = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        alert.showAlertInView(self,
                              withTitle: "Attention".localized(),
                              withSubtitle: message.localized(),
                              withCustomImage: nil,
                              withDoneButtonTitle: "Ok".localized(),
                              andButtons: nil)
    }
    
    func beginLoginSequence() {
        if txtUserName.text == "" {
            showAlert("pleaseEnterEmail")
        } else if (!txtUserName.text!.isValidEmail()) {
            showAlert("emailInvalid")
        } else if txtPassword.text == "" {
            showAlert("pleaseEnterPassword")
        } else if txtPassword.text!.characters.count < 8 {
            showAlert("passwordLengthError")
        }
        else {
            if isSimulator {
                sendLoginRequest(txtUserName.text!, password:txtPassword.text!, pushToken: "IOS_RUNNING_FROM_SIMULATOR")
            }else {
                sendLoginRequest(txtUserName.text!, password:txtPassword.text!, pushToken: PushToken)
            }
        }
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
        let body = LoginRequest(email: email, device_token: pushToken, password: password).getDic()
        
        // Fetch Request
        Request.postData(url,body: body) { (response:UserManagementModel<LoginResponse>?, error) in
            
            if ((response?.success) != nil) {
                
                
                if response!.result != nil {
                    if response!.errorCode == 200 {
                        LoginToken = response!.result.apiToken!
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
                } else if response!.errorCode == 202 {
                    
                    self.showAlert("emailOrPasswordInvalid".localized())
                }
                self.btnLogin.enabled = true
                progress.stopAnimating()
            }else {
                debugPrint(response?.error?.email)
                self.btnLogin.enabled = true
                progress.stopAnimating()
            }
            
        }
    }
    
}