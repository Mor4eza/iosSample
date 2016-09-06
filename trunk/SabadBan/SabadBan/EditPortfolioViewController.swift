    //
    //  EditPortfolioViewController.swift
    //  SabadBan
    //
    //  Created by Morteza Gharedaghi on 9/4/16.
    //  Copyright © 2016 Sefr Yek. All rights reserved.
    //
    
    import UIKit
    
    class EditPortfolioViewController: BaseTableViewController {
        
        @IBOutlet weak var etTitle: UITextField!
        var portfolioName = String()
        var db = DataBase()
        var symbolData = [symbolsDataForEdit]()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "EditPortfolio".localized()
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
            etTitle.text = portfolioName
            etTitle.changeDirection()
            let btnDone = UIButton()
            btnDone.setTitle("Done".localized(), forState: .Normal)
            btnDone.frame = CGRectMake(0, 0, 45, 45)
            btnDone.addTarget(self, action: #selector(doneClicked), forControlEvents: .TouchUpInside)
            let rightBarButton = UIBarButtonItem(customView: btnDone)
            self.navigationItem.leftBarButtonItem = rightBarButton
            
            setEditing(true, animated: true)

        }
        
        func doneClicked()  {
            db.updatePortfolioName(etTitle.text!, pCode: db.getportfolioCodeByName(portfolioName))
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Table view data source
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return symbolData.count
        }
        
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("editPortfolioCell", forIndexPath: indexPath)
            
            if getAppLanguage() == "fa"{
                cell.textLabel?.text = symbolData[indexPath.row].sName
            }else if getAppLanguage() == "en" {
                cell.textLabel?.text = symbolData[indexPath.row].sNameEn
                
            }
            cell.backgroundColor = AppMainColor
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.changeDirection()
            return cell
        }
        
        
        
        // Override to support conditional editing of the table view.
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        
        
        override func setEditing(editing: Bool, animated: Bool) {
            super.setEditing(editing, animated: animated)
        }
        // Override to support editing the table view.
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                // Delete the row from the data source
                db.deleteSymbolFromPortfoi(symbolData[indexPath.row].sCode, pCode: db.getportfolioCodeByName(portfolioName))
                symbolData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            }
        }
        
        
    }
    
    struct symbolsDataForEdit {
        var sName = String()
        var sNameEn = String()
        var sCode = String()
    }
