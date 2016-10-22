//
//  ForgetPasswordViewController.swift
//  SabadBan
//
//  Created by PC22 on 10/22/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Update
    func initView() {
        descriptionLabel.text = Strings.forgetPasswordDescription
        loginButton.setTitle(Strings.ForgetPassword, forState: .Normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
