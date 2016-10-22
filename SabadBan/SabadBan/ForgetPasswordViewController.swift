//
//  ForgetPasswordViewController.swift
//  SabadBan
//
//  Created by PC22 on 10/22/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: BaseViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == txtUsername {
            resignFirstResponder()
            self.view.endEditing(true)
            initiateForgetPassSequence()
        }
        
        return true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Update
    func initView() {
        descriptionLabel.text = Strings.forgetPasswordDescription.localized()
        loginButton.setTitle(Strings.forgetPasswordSendKey.localized(), forState: .Normal)
        
        btnLogin.setTitle(Strings.Login.localized(), forState: .Normal)
        sendButton.setTitle(Strings.forgetPasswordSendKey.localized(), forState: .Normal)
        txtUsername.placeholder = Strings.Email.localized()
        
        txtUsername.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func btnLogin(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnSendForget(sender: UIButton) {
        initiateForgetPassSequence()
    }
    
    func initiateForgetPassSequence() {
        
        if let email = txtUsername.text {
            guard !(email.isEmpty) else {
                Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.pleaseEnterEmail.localized())
                return
            }
            guard (email.isValidEmail()) else {
                Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.emailInvalid.localized())
                return
            }
            sendForgetPasswordRequest(email)
        }
        
    }
    
    
    //MARK: - Services
    
    func sendForgetPasswordRequest(email : String) {
        sendButton.enabled = false
        let progress:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progress.frame = CGRectMake(sendButton.bounds.maxX - 30, sendButton.bounds.maxY - 33, 20, 20)
        progress.startAnimating()
        sendButton.addSubview(progress)
        progress.hidesWhenStopped = true
        let url = AppNewsURL + URLS["changePassword"]!
        
        // JSON Body
        let body = ForgetPasswordRequest(email: email).getDic()
        
        // Fetch Request
        Request.postData(url, body: body) { (forgetPassword:ForgetPasswordResponse?, error) in
            
            if ((forgetPassword?.success) != nil) {
                if forgetPassword!.result != nil {
                    if forgetPassword!.errorCode == 300 {
                        Utils.ShowAlert(self, title: Strings.changePassword.localized(), details: Strings.changePasswordSuccessMessage.localized())
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else if forgetPassword!.errorCode == 302 {
                    Utils.ShowAlert(self, title: Strings.changePassword.localized(), details: Strings.emailNotFound.localized())
                }
                
                self.sendButton.enabled = true
                progress.stopAnimating()
            } else {
                debugPrint(error)
                self.sendButton.enabled = true
                progress.stopAnimating()
            }
        }
    }
    
}
