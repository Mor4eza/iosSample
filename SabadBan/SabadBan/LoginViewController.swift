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
    lazy var defaults = NSUserDefaults.standardUserDefaults()
    var guestUserName: String!
    var updateUrl = String()
    var rootAlert: FCAlertView?
    var updateAlert: FCAlertView?
    lazy var db = DataBase()

    override func viewDidLoad() {
        super.viewDidLoad()

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

        checkVersionRequest()

        checkForJailBreak()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
        isGuest = false
    }

    @IBAction func btnGuestLoginTap(sender: AnyObject) {

        if defaults.stringForKey(GuestUserName) == nil {
            if isSimulator {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: Strings.SimulatorPushToken, guest: true)
            } else {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: PushToken, guest: true)
            }
        } else {

            GuestUser = defaults.stringForKey(GuestUserName)!
            GuestPass = defaults.stringForKey(GuestPassword)!
            if isSimulator {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: Strings.SimulatorPushToken)
            } else {
                sendLoginRequest(GuestUser, password: GuestPass, pushToken: PushToken)
            }
        }
        isGuest = true
    }


    func showAlert(message: String) {

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
        } else {
            if isSimulator {
                sendLoginRequest(txtUserName.text!, password: txtPassword.text!, pushToken: Strings.SimulatorPushToken)
            } else {
                sendLoginRequest(txtUserName.text!, password: txtPassword.text!, pushToken: PushToken)
            }
        }
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {

        if identifier == UIConstants.loginSegue {
            if successLogin {
                return true
            } else {
                return false
            }

        }
        return true
    }

    //MARK:- Login Service

    func sendLoginRequest(email: String, password: String, pushToken: String, guest: Bool? = nil) {
        /**
         Login
         POST http://sabadbannewstest.sefryek.com/api/v1/auth/login
         */

        btnLogin.enabled = false
        btnGuestLogin.enabled = false
        let progress: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progress.frame = CGRectMake(btnLogin.bounds.maxX - 30, btnLogin.bounds.maxY - 33, 20, 20)
        progress.startAnimating()
        var url: String?
        if guest == true {
            btnGuestLogin.addSubview(progress)
            url = AppNewsURL + URLS["guestLogin"]!
        } else {
            btnLogin.addSubview(progress)
            url = AppNewsURL + URLS["login"]!
        }
        progress.hidesWhenStopped = true


        // JSON Body
        let body = LoginRequest(email: email, device_token: pushToken, password: password).getDic()

        // Fetch Request
        Request.postData(url!, body: body) {
            (response: UserManagementModel<LoginResponse>?, error) in

            if ((response?.success) != nil) {

                if response!.result != nil {

                    let userId = self.db.getUserId(email)
                    if (userId != -1) {
                        LogedInUserId = userId
                    } else {
                        if (email != GuestUser) {
                            self.db.addUser(email)
                            LogedInUserId = self.db.getUserId(email)
                        }
                    }

                    if response!.errorCode == 100 {
                        self.guestUserName = response?.result.email

                        let delimiter = "@"
                        var name = self.guestUserName.componentsSeparatedByString(delimiter)
                        print(name[0])

                        self.defaults.setValue(self.guestUserName, forKey: GuestUserName)
                        self.defaults.setValue(name[0], forKey: GuestPassword)
                        if isSimulator {
                            self.sendLoginRequest(self.guestUserName, password: name[0], pushToken: Strings.SimulatorPushToken)
                        } else {
                            self.sendLoginRequest(self.guestUserName, password: name[0], pushToken: PushToken)
                        }
                    }


                    if response!.errorCode == 200 {

                        LoginToken = response!.result.apiToken!
                        self.successLogin = true
                        LogedInUserName = email
                        self.dismissViewControllerAnimated(false, completion: nil)
                        self.performSegueWithIdentifier(UIConstants.loginSegue, sender: nil)

                        if guest == false {
                            if self.chkRemember.on == true {
                                self.defaults.setValue(email, forKey: UserName)
                                self.defaults.setValue(password, forKey: Password)
                            } else {
                                self.defaults.setValue(nil, forKey: UserName)
                                self.defaults.setValue(nil, forKey: Password)
                            }
                        }
                        let loginCount = self.defaults.integerForKey(NumberOfLogins)
                        if (loginCount < 4) {
                            self.defaults.setValue((loginCount + 1), forKeyPath: NumberOfLogins)
                        }
                    }
                } else if response!.errorCode == 202 {

                    self.showAlert(Strings.emailOrPasswordInvalid.localized())
                    self.view.endEditing(true)
                }
                self.btnLogin.enabled = true
                self.btnGuestLogin.enabled = true
                progress.stopAnimating()
            } else {
                debugPrint(response?.error?.email)
                self.btnLogin.enabled = true
                self.btnGuestLogin.enabled = true
                self.view.endEditing(true)
                progress.stopAnimating()
            }

        }
    }

    // MARK: - Check Version Service

    func checkVersionRequest() {

        let url = AppTadbirUrl + URLS["checkVersionCode"]!

        // JSON Body
        let body = CheckVersionCodeRequest(osVersion: UIDevice.currentDevice().systemVersion, osName: "IOS", versionCode: Double(appVersionName!)).getDic()

        // Fetch Request
        Request.postData(url, body: body) {
            (response: MainResponse<CheckVersionCodeResponse>?, error) in

            if ((response?.successful) != nil) {

                if response!.response != nil {

                    if !(response?.response.upToDate)! {
                        self.updateUrl = (response?.response.updateLink)!
                        let description = (getAppLanguage() == Language.en.rawValue) ? response?.response.descriptionEn : response?.response.descriptionFa
                        self.updateAlert = Utils.ShowAlert(self, title: Strings.Attention.localized(), details: description!, btnOkTitle: Strings.download.localized(), delegate: self)
                    }

                    updateServiceInterval = (Double((response?.response.updateTimer)!) / 1000)

                }
            }
        }
    }

    // MARK: - FCAlert Delegates

    func FCAlertDoneButtonClicked(alertView: FCAlertView!) {

        if alertView == updateAlert {
            if let checkURL = NSURL(string: updateUrl) {
                UIApplication.sharedApplication().openURL(checkURL)
            }
        } else if alertView == rootAlert {
            self.defaults.setValue(true, forKey: JailBreakAccept)
        }

    }

    override func FCAlertViewDismissed(alertView: FCAlertView!) {
        super.FCAlertViewDismissed(alertView)
        if (alertView == updateAlert) {
            exit(0)
        } else if (alertView == rootAlert) {
            if !self.defaults.boolForKey(JailBreakAccept) {
                exit(0)
            }
        }

    }

    //MARK: - Jail break check
    func checkForJailBreak() {

        if !defaults.boolForKey(JailBreakAccept) {
            if isJailbroken() {
                dispatch_async(dispatch_get_main_queue()) {

                    self.rootAlert = Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.isJailBrokenDescription.localized(), btnOkTitle: Strings.Yes.localized(), btnTitles: [Strings.No.localized()], delegate: self)

                }

            }
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

}
