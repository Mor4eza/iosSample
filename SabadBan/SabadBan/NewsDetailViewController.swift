//
//  NewsDetailViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/10/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController{

    
    
    var newsTitle = String()
    var newsDetails = String()
    var newsDate = String()
    var newsLink = String()
    
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
    }

    func fillData (){
        
        lblTitle.text = newsTitle
        txtDescription.text = newsDetails
        lblDate.text = newsDate
    }
   
    

  
}
