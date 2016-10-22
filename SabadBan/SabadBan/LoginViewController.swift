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

    @IBOutlet weak var btnGuestLogin: UIButton!
    @IBOutlet weak var btnForgetPass: UIButton!
    lazy var successLogin = false
    lazy var defaults  = NSUserDefaults.standardUserDefaults()
    var guestUserName:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        //        self.view.transform = CGAffineTransformMakeScale(-1, 1)
        //        lblRememberMe.transform = CGAffineTransformMakeScale(-1, 1)
        // Do any additional setup after loading the view.

        //MARK: - Login String


        lblRememberMe.text = Strings.RememberMe.localized()
        btnLogin.setTitle(Strings.Login.localized(), forState: .Normal)
        txtUserName.placeholder = Strings.Email.localized()
        txtPassword.placeholder = Strings.Password.localized()
        btnRegister.setTitle(Strings.Register.localized(), forState: .Normal)
        btnForgetPass.setTitle(Strings.ForgetPassword.localized(), forState: .Normal)
        btnGuestLogin.setTitle(Strings.GuestLogin.localized(), forState: .Normal)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        debugPrint(defaults.stringForKey(UserName))
        if defaults.stringForKey(UserName) != nil {
            chkRemember.setOn(true, animated: true)
        }

        if chkRemember.on == true {
            txtUserName.text = defaults.stringForKey(UserName)
            txtPassword.text = defaults.stringForKey(Password)
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

    @IBAction func btnGuestLoginTap(sender: AnyObject) {

        if defaults.stringForKey(GuestUserName) == nil {
            if isSimulator {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: Strings.SimulatorPushToken ,guest: true)
            }else {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: PushToken ,guest: true)
            }
        }else {

            GuestUser = defaults.stringForKey(GuestUserName)!
            GuestPass = defaults.stringForKey(GuestPassword)!
            if isSimulator {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: Strings.SimulatorPushToken )
            }else {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: PushToken)
            }
        }
    }


    func showAlert(message : String) {

        Utils.ShowAlert(self,
                        title: Strings.Attention.localized(),
                        details: message.localized(),
                        btnOkTitle: Strings.Ok.localized()
        )
    }

    func beginLoginSequence() {
        self.view.endEditing(true)
        if txtUserName.text == "" {
            showAlert(Strings.pleaseEnterEmail)
        } else if (!txtUserName.text!.isValidEmail()) {
            showAlert(Strings.emailInvalid)
        } else if txtPassword.text == "" {
            showAlert(Strings.pleaseEnterPassword)
        } else if txtPassword.text!.characters.count < 8 {
            showAlert(Strings.passwordLengthError)
        }
        else {
            if isSimulator {
                sendLoginRequest(txtUserName.text!, password:txtPassword.text!, pushToken:Strings.SimulatorPushToken)
            }else {
                sendLoginRequest(txtUserName.text!, password:txtPassword.text!, pushToken: PushToken)
            }
        }
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {

        if identifier == UIConstants.loginSegue {
            if successLogin {
                return true
            }else {
                return false
            }

        }
        return true
    }

    //MARK:- Login Service

    func sendLoginRequest(email:String , password:String , pushToken:String,guest:Bool? = nil ) {
        /**
         Login
         POST http://sabadbannewstest.sefryek.com/api/v1/auth/login
         */
        debugPrint(guest)
        btnLogin.enabled = false
        btnGuestLogin.enabled = false
        let progress:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progress.frame = CGRectMake(btnLogin.bounds.maxX - 30, btnLogin.bounds.maxY - 33, 20, 20)
        progress.startAnimating()
        var url:String?
        if guest == true {
            btnGuestLogin.addSubview(progress)
            url = AppNewsURL + URLS["guestLogin"]!
        }else {
            btnLogin.addSubview(progress)
            url = AppNewsURL + URLS["login"]!
        }
        progress.hidesWhenStopped = true


        // JSON Body
        let body = LoginRequest(email: email, device_token: pushToken, password: password).getDic()

        // Fetch Request
        Request.postData(url!,body: body) { (response:UserManagementModel<LoginResponse>?, error) in

            if ((response?.success) != nil) {

                if response!.result != nil {

                    if response!.errorCode == 100 {
                        self.guestUserName = response?.result.email

                        let delimiter = "@"
                        var name = self.guestUserName.componentsSeparatedByString(delimiter)
                        print (name[0])

                        self.defaults.setValue(self.guestUserName, forKey: GuestUserName)
                        self.defaults.setValue(name[0], forKey: GuestPassword)
                        if isSimulator {
                            self.sendLoginRequest(self.guestUserName, password:name[0], pushToken:Strings.SimulatorPushToken)
                        }else {
                            self.sendLoginRequest(self.guestUserName, password:name[0], pushToken: PushToken)
                        }
                    }


                    if response!.errorCode == 200 {

                        LoginToken = response!.result.apiToken!
                        self.successLogin = true
                        LogedInUserName = email
                        self.performSegueWithIdentifier(UIConstants.loginSegue, sender: nil)

                        if self.chkRemember.on == true {
                            self.defaults.setValue(email, forKey: UserName)
                            self.defaults.setValue(password, forKey: Password)
                        }else {
                            self.defaults.setValue(nil, forKey: UserName)
                            self.defaults.setValue(nil, forKey: Password)
                        }
                    }
                } else if response!.errorCode == 202 {

                    self.showAlert(Strings.emailOrPasswordInvalid.localized())
                    self.view.endEditing(true)
                }
                self.btnLogin.enabled = true
                self.btnGuestLogin.enabled = true
                progress.stopAnimating()
            }else {
                debugPrint(response?.error?.email)
                self.btnLogin.enabled = true
                self.btnGuestLogin.enabled = true
                self.view.endEditing(true)
                progress.stopAnimating()
            }
            
        }
    }
    
    
}
