
//
//  CallUsViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/27/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class CallUsViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {



    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imgCrash: UIImageView!

    @IBOutlet weak var lblName: UITextField!


    @IBOutlet weak var lblEmail: UITextField!


    @IBOutlet weak var lblSubject: UITextField!


    @IBOutlet weak var lblDetails: UITextField!

    @IBOutlet weak var btnSend: UIButton!

    @IBOutlet weak var btnInfo: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addMenuButton()
        initViews()
        imagePicker.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(CallUsViewController.imageTapped(_:)))
        imgCrash.userInteractionEnabled = true
        imgCrash.addGestureRecognizer(tapGestureRecognizer)
    }

    func imageTapped(img: AnyObject)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary

        presentViewController(imagePicker, animated: true, completion: nil)

    }


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgCrash.contentMode = .ScaleAspectFit
            imgCrash.image = pickedImage
        }

        dismissViewControllerAnimated(true, completion: nil)
    }


    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }



    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func initViews(){

        lblName.placeholder = Strings.SenderName.localized()
        lblEmail.placeholder = Strings.SenderEmail.localized()
        lblSubject.placeholder = Strings.EmailSubject.localized()
        lblDetails.placeholder = Strings.EmailMessage.localized()
        lblName.text = ""
        lblEmail.text = ""
        lblSubject.text = ""
        lblDetails.text = ""
        btnSend.setTitle(Strings.Send.localized(), forState: .Normal)
        btnInfo.setTitle(Strings.ContactInfo.localized(), forState: .Normal)
        self.title = Strings.ContactUs.localized()
    }

    @IBAction func btnSendTap(sender: AnyObject) {

        var imageData = UIImage()
        if !(imgCrash.image?.isEqual(UIImage(named: UIConstants.selectPicture)))! {
            imageData = imgCrash.image!
        }

        sendInformation(lblName.text!,
                        Cemail: lblEmail.text!,
                        Csubject: lblSubject.text!,
                        Cmessage: lblDetails.text!,
                        Cimage:imageData )

    }

    @IBAction func btnInfoTap(sender: AnyObject) {
        
    }



    //MARK:- Send Data

    func sendInformation(Cname:String ,Cemail:String , Csubject:String , Cmessage:String , Cimage: UIImage? = nil){

        let url = AppNewsURL + URLS["sendContactUs"]!
        let parameters = ContactUsRequest(name: Cname,email: Cemail,subject: Csubject,message: Cmessage).getDic()
        btnSend.enabled = false
        let progress:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progress.frame = CGRectMake(btnSend.bounds.maxX - 30, btnSend.bounds.maxY - 33, 20, 20)
        progress.startAnimating()
        btnSend.addSubview(progress)
        progress.hidesWhenStopped = true

        Alamofire.upload(
            .POST,
            url,
            multipartFormData: { multipartFormData in

                if Cimage != nil {
                    if let imageData = UIImageJPEGRepresentation(Cimage!, 1) {
                        multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: Strings.SenderEmail, mimeType: "image/png")
                    }
                }
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)

                        Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.Successful.localized())
                        self.btnSend.enabled = true
                        progress.stopAnimating()
                        self.initViews()
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.Faild.localized())
                    self.btnSend.enabled = true
                    progress.stopAnimating()
                }
            }
        )
        
    }
    
}
