//
//  PortfolioListViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/30/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import ActionButton
import SQLite
class PortfolioListViewController: BaseViewController {
    let db = DataBase()
    var actionButton: ActionButton!
    var currentPortfolio = String()
    var portfolios = [String]()
    var menuView:BTNavigationDropdownMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationTitle()
        initFloationButton()
    }
    
    func initNavigationTitle(){
        
         portfolios = db.getPortfolioList(1)
        if portfolios.count > 0 {
            currentPortfolio = portfolios[0]
          menuView = BTNavigationDropdownMenu(title: portfolios[0], items: portfolios)
        }else {
        menuView = BTNavigationDropdownMenu(title: "Portfolio".localized(), items: portfolios)
        }
        menuView.animationDuration = 0.5
        menuView.cellTextLabelAlignment = NSTextAlignment.Center
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
            self.currentPortfolio = self.portfolios[indexPath]
        }
        
        
        
    }
    
    func initFloationButton(){
        
        let addPortfolio = ActionButtonItem(title: "AddPortfolio".localized(), image: UIImage(named: "ic_add_portfolio"))
        addPortfolio.action = { item in

        
            var tField: UITextField!
            
            func configurationTextField(textField: UITextField!)
            {
                textField.placeholder = "EnterPortfolioName".localized()
                textField.changeDirection()
                tField = textField
            }
            
            func handleCancel(alertView: UIAlertAction!)
            {
            }
            
            let alert = UIAlertController(title: "AddPortfolio".localized(), message: "", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Submit".localized(), style: .Default, handler:{ (UIAlertAction) in
                
                if !(tField.text?.isEmpty)! {
                   
                    for i in 0  ..< self.portfolios.count {
                        if(tField.text == self.portfolios[i]){
                            let dialog = MyAlert()
                            dialog.showAlert("توجه", details: "این پرتفوی قبلا اضافه شده است", okTitle: "باشه", cancelTitle: "", onView: self.view)
                            return
                        }
                    }
                self.db.addPortfolio(tField.text!)
                self.initNavigationTitle()
                }else {
                
                    
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        
        }
        
        
        
        let editPortfolio = ActionButtonItem(title: "EditPortfolio".localized(), image: UIImage(named: "ic-edit_portfolio"))
        editPortfolio.action = { item in
            
           
            
        }
        
        let searchSymbol = ActionButtonItem(title: "SearchSymbol".localized(), image: UIImage(named: "ic_search"))
        searchSymbol.action = { item in
            
            
            let serchViewConntroller:SearchSeymbolTableView = SearchSeymbolTableView()
            self.presentViewController(serchViewConntroller, animated: true, completion: nil)
            
        }
        
        
        let addSymbol = ActionButtonItem(title: "AddSymbol".localized(), image: UIImage(named: "ic_add_symbol"))
        addSymbol.action = { item in
            
        }
        
        let deletePortfolio = ActionButtonItem(title: "DeletePortfolio".localized(), image: UIImage(named: "ic_delete_portfolio"))
        deletePortfolio.action = { item in
            
            self.db.deletePortfolio(self.db.getportfolioCodeByName(self.currentPortfolio))
            self.initNavigationTitle()
            
        }
        
        if portfolios.count == 0{
            
            actionButton = ActionButton(attachedToView: view, items: [addPortfolio])
            actionButton.action = { button in button.toggleMenu() }
        
        }else{
            
            actionButton = ActionButton(attachedToView: view, items: [addPortfolio, editPortfolio,searchSymbol,addSymbol,deletePortfolio])
            actionButton.action = { button in button.toggleMenu() }
        }
        
    }
    
    
}
