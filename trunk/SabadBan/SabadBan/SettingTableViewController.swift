//
//  SettingTableViewController.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/17/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import Localize_Swift
import SwiftEventBus

class SettingTableViewController: BaseTableViewController {

    var actionSheet: UIAlertController!
    let availableLanguages = Localize.availableLanguages()

    override func viewDidLoad() {
        super.viewDidLoad()
        super.addMenuButton()
        setTexts()
        self.tableView.contentInset = UIEdgeInsets(top: -60, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Right

        label.changeDirection()

        if section == 1 {
            label.text = Strings.Language.localized()
        }

        return label
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 1 {
            return 0
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.settingCell, forIndexPath: indexPath)

        cell.textLabel?.changeDirection()

        if indexPath.section == 1 {
            cell.textLabel?.text = Localize.displayNameForLanguage(Localize.currentLanguage())
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == 0 {
            actionSheet = UIAlertController(title: nil, message: Strings.SwitchLanguage.localized(), preferredStyle: UIAlertControllerStyle.ActionSheet)
            for language in availableLanguages {
                let displayName = Localize.displayNameForLanguage(language)
                let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    Localize.setCurrentLanguage(language)
                    SwiftEventBus.post(LanguageChangedNotification)
                    self.tableView.reloadData()
                })
                actionSheet.addAction(languageAction)
            }
            let cancelAction = UIAlertAction(title: Strings.Cancel.localized(), style: UIAlertActionStyle.Cancel, handler: {
                (alert: UIAlertAction) -> Void in
            })
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            actionSheet.popoverPresentationController?.sourceView = cell
            actionSheet.popoverPresentationController?.sourceRect = (cell?.textLabel?.bounds)!
            actionSheet.addAction(cancelAction)
            presentViewController(actionSheet, animated: true, completion: nil)
        }

    }

    // MARK: - view delegates
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setTexts), name: LCLLanguageChangeNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setTexts() {
        self.title = Strings.Setting.localized()

    }

}
