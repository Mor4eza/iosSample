//
//  NewsDetailViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/10/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    var newsTitle = String()
    var newsDetails = String()
    var newsDate = String()
    var newsLink = String()

    @IBOutlet weak var btnUrl: UIBarButtonItem!
    @IBOutlet weak var btnShare: UIBarButtonItem!

    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var txtDescription: UITextView!

    @IBOutlet weak var lblDate: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtDescription.changeDirection()
        lblTitle.setDefaultFont()
        lblDate.setDefaultFont()
        txtDescription.setDefaultFont()
        lblTitle.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        lblTitle.numberOfLines = 0
        lblTitle.changeDirection()
        fillData()
        if newsLink.isEmpty {
            btnUrl.enabled = false
        }
    }

    func fillData() {

        lblTitle.text = newsTitle
        txtDescription.text = newsDetails
        lblDate.text = newsDate
    }

    @IBAction func btnShareTap(sender: AnyObject) {

        let appSign = Strings.appName.localized()
        let vc = UIActivityViewController(activityItems: [newsTitle, "\n \n", newsDetails + "\n \n", appSign], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = btnShare
        presentViewController(vc, animated: true, completion: nil)

    }

    @IBAction func btnUrlTap(sender: AnyObject) {

        if let url = NSURL(string: newsLink) {

            UIApplication.sharedApplication().openURL(url)
        }
    }

}
