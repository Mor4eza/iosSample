//
//  RegisterViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/14/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
import FCAlertView

class RegisterViewController: BaseViewController, UITextFieldDelegate {

    //MARK: Properties

    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!

    @IBOutlet weak var txtRPassword: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForgetPassword: UIButton!


    var defaults = NSUserDefaults.standardUserDefaults()

    var successLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()

        //        self.view.transform = CGAffineTransformMakeScale(-1, 1)
        //        lblRememberMe.transform = CGAffineTransformMakeScale(-1, 1)
        // Do any additional setup after loading the view.

        //MARK: - Register String

        txtUserName.placeholder = Strings.Email.localized()
        txtPassword.placeholder = Strings.Password.localized()
        btnRegister.setTitle(Strings.Register.localized(), forState: .Normal)
        btnForgetPassword.setTitle(Strings.ForgetPassword.localized(), forState: .Normal)
        txtPhone.placeholder = Strings.Tell.localized()
        txtRPassword.placeholder = Strings.RepeatPass.localized()
        btnLogin.setTitle(Strings.Login.localized(), forState: .Normal)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        txtUserName.delegate = self
        txtPhone.delegate = self
        txtPassword.delegate = self
        txtRPassword.delegate = self

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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == txtUserName {
            txtPhone.becomeFirstResponder()
        } else if textField == txtPhone {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtRPassword.becomeFirstResponder()
        } else if textField == txtRPassword {
            textField.resignFirstResponder()
            beginRegisterSequence()
        }

        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK:- Buttons Tap

    @IBAction func btnRegisterTap(sender: AnyObject) {
        beginRegisterSequence()
    }

    func beginRegisterSequence() {
        self.view.endEditing(true)

        if txtUserName.text == "" {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.pleaseEnterEmail.localized())
        } else if (!txtUserName.text!.isValidEmail()) {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.emailInvalid.localized())
        } else if txtPhone.text == "" {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.pleaseEnterPhoneNumber.localized())
        } else if txtPhone.text?.characters.count < 11 {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.phoneNumberLengthError.localized())
        } else if txtPassword.text == "" {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.pleaseEnterPassword.localized())
        } else if txtPassword.text!.characters.count < 8 {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.passwordLengthError.localized())
        } else if txtRPassword.text == "" {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.pleaseEnterPasswordRepeat.localized())
        } else if !(txtRPassword.text == txtPassword.text) {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.passwordRepeatNotMatch.localized())
        } else {
            if isSimulator {
                sendRegisterRequest(txtUserName.text!, password: txtPassword.text!, phone: txtPhone.text!, pushToken: "IOS_RUNNING_IN_SIMULATOR")
            } else {
                sendRegisterRequest(txtUserName.text!, password: txtPassword.text!, phone: txtPhone.text!, pushToken: PushToken)
            }
        }
    }

    @IBAction func btnLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func btnForgetPassword(sender: UIButton) {

        let mainStoryboard: UIStoryboard = UIStoryboard(name: UIConstants.Main, bundle: nil)
        let destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("forgetPasswordViewController")

        let presentingViewController: UIViewController! = self.presentingViewController

        self.dismissViewControllerAnimated(false, completion: {
            presentingViewController.presentViewController(destViewController, animated: true, completion: nil)
        })
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone {
//            guard let text = textField.text else { return true }
//
//            let newLength = text.utf16.count + string.utf16.count - range.length
//            return newLength <= 11

            let aSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
            let numberFiltered = compSepByCharInSet.joinWithSeparator("")
            return string == numberFiltered
        }
        return true
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {

        if identifier == UIConstants.registerSegue {
            if successLogin {
                return true
            } else {
                return false
            }

        }
        return true
    }

    //MARK:- Login Service

    func sendRegisterRequest(email: String, password: String, phone: String, pushToken: String) {
        /**
         ChangePassword
         POST http://sabadbannewstest.sefryek.com/api/v1/auth/changePassword
         */

        btnRegister.enabled = false
        let progress: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progress.frame = CGRectMake(btnRegister.bounds.maxX - 30, btnRegister.bounds.maxY - 33, 20, 20)
        progress.startAnimating()
        btnRegister.addSubview(progress)
        progress.hidesWhenStopped = true
        let url = AppNewsURL + URLS["register"]!

        // JSON Body
        let body = RegisterRequest(email: email, device_token: pushToken, password: password, phone: phone).getDic()

        // Fetch Request
        Request.postData(url, body: body) {
            (register: UserManagementModel<RegisterResponse>?, error) in

            if ((register?.success) != nil) {
                if register!.result != nil {
                    if register!.errorCode == 100 {
                        LoginToken = register!.result.apiToken!
                        self.successLogin = true
                        LogedInUserName = email
                        //                            self.dismissViewControllerAnimated(true, completion: nil)
                        self.defaults.setValue(email, forKey: UserName)
                        self.performSegueWithIdentifier(UIConstants.registerSegue, sender: nil)

                    }
                } else if register!.errorCode == 101 {
                    if (register!.error?.unigueEmail != nil) {
                        Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.emailRegisterdBefore.localized())
                    }
                } else if register!.errorCode == 102 {
                    Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.unknownRegisterError.localized())
                }

                self.btnRegister.enabled = true
                progress.stopAnimating()
            } else {
                debugPrint(error)
                self.btnRegister.enabled = true
                progress.stopAnimating()
            }
        }

    }

}
