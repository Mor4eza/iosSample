//
//  EditPortfolioViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/4/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import SwiftEventBus

class EditPortfolioViewController: BaseTableViewController {

    @IBOutlet weak var etTitle: UITextField!
    var portfolioName = String()
    var db = DataBase()
    var symbolData = [symbolsDataForEdit]()
    var portfolios = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Strings.EditPortfolio.localized()
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        etTitle.text = portfolioName
        etTitle.maxLength = 30
        etTitle.changeDirection()
        let rightBarButton = UIBarButtonItem(image: UIImage(named: UIConstants.icDone), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doneClicked))
        self.navigationItem.leftBarButtonItem = rightBarButton

        setEditing(true, animated: true)

    }

    func doneClicked() {

        for i in 0 ..< self.portfolios.count {
            if etTitle.text != portfolioName {
                if (etTitle.text == self.portfolios[i]) {
                    Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.nameDuplicate.localized(), btnOkTitle: Strings.Ok.localized())
                    return
                }
            }
        }

        db.updatePortfolioName(etTitle.text!, pCode: db.getportfolioCodeByName(portfolioName))
        dismissViewControllerAnimated(true, completion: { SwiftEventBus.postToMainThread(PortfolioEdited) })
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
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.editPortfolioCell, forIndexPath: indexPath)

        if getAppLanguage() == Language.fa.rawValue {
            cell.textLabel?.text = symbolData[indexPath.row].sName
        } else if getAppLanguage() == Language.en.rawValue {
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
            let psCode = db.getPsCodeBySymbolCode(symbolData[indexPath.row].sCode, pCode: 1)

            db.deletePsBuybyPSCode(psCode)
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
