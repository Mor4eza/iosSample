//
//  SymbolListTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire

class SymbolListTableViewController: BaseTableViewController {

    //MARK: Properties
    var numberSortCondiiton = SortCondition.notSorted
    var volumeSortCondiiton = SortCondition.notSorted
    var symbolSortCondiiton = SortCondition.notSorted

    var isScrolling = false

    var headerView: SymbolListHeader!
    var lastUpdate = NSMutableAttributedString()
    var symbolDetailsList = [SymbolDetailsList]()
    var temp = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.registerNib(UINib(nibName: UIConstants.SymbolListHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.SymbolListHeader)

        self.tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = UIColor.whiteColor()
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height)

        refreshControl!.addTarget(self, action: #selector(SymbolListTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        getSymbolListByIndex()

    }

    func refresh(sender: AnyObject) {
        getSymbolListByIndex()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return symbolDetailsList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.symbolCell, forIndexPath: indexPath) as! SymbolCell

//        dispatch_async(dispatch_get_main_queue()){
        cell.initReuseCell(self.symbolDetailsList[indexPath.row], indexPathRow: indexPath.row)
//        }


        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.SymbolListHeader) as! SymbolListHeader

        let tapGestureAmount = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        let tapGestureVolume = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        let tapGestureName = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        let tapGestureImgName = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        let tapGestureImgAmount = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        let tapGestureImgVolume = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))

        headerView.lblAmount.addGestureRecognizer(tapGestureAmount)
        headerView.lblAmount.userInteractionEnabled = true
        headerView.imgSortAmount.addGestureRecognizer(tapGestureImgAmount)
        headerView.imgSortAmount.userInteractionEnabled = true

        headerView.lblVolume.addGestureRecognizer(tapGestureVolume)
        headerView.lblVolume.userInteractionEnabled = true
        headerView.imgSortVolume.addGestureRecognizer(tapGestureImgVolume)
        headerView.imgSortVolume.userInteractionEnabled = true

        headerView.lblName.addGestureRecognizer(tapGestureName)
        headerView.lblName.userInteractionEnabled = true
        headerView.imgSortName.addGestureRecognizer(tapGestureImgName)
        headerView.imgSortName.userInteractionEnabled = true

        headerView.lblName.text = Strings.Symbol.localized()
        headerView.lblLastTrade.text = Strings.Trade.localized()
        headerView.lblAmount.text = Strings.Amount.localized()
        headerView.lblVolume.text = Strings.Volume.localized()

        headerView.lblName.setDefaultFont()
        headerView.lblLastTrade.setDefaultFont()
        headerView.lblAmount.setDefaultFont()
        headerView.lblVolume.setDefaultFont()
        headerView.lblLastUpdate.attributedText = lastUpdate
        return headerView
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SelectedSymbolCode = symbolDetailsList[indexPath.row].symbolCode
    }

    //MARK: - Service Call

    func getSymbolListByIndex() {

        refreshControl?.beginRefreshing()
        let url = AppTadbirUrl + URLS["getSymbolListByIndex"]!

        // JSON Body
        let body = SymbolListByIndexRequest(pageNumber: 0, recordPerPage: 0, indexCode: SelectedIndexCode, supportPaging: false, timeFrameType: TimeFrameType.day.rawValue, language: getAppLanguage()).getDic()

        // Fetch Request
        Request.postData(url, body: body) {
            (symbols: MainResponse<SymbolListByIndexResponse>?, error) in

            if ((symbols?.successful) != nil) {
                self.symbolDetailsList.removeAll()
                self.lastUpdate = (symbols?.convertTime())!
                for i in 0 ..< symbols!.response.symbolDetailsList.count {
                    self.symbolDetailsList.append(symbols!.response.symbolDetailsList[i])
                    self.tableView.reloadData()
                }
            } else {
                debugPrint(error)
            }

            self.refreshControl?.endRefreshing()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "symbolDetailsSegue" {
            
            let backItem = UIBarButtonItem()
            backItem.title = Strings.Back.localized()
            navigationItem.backBarButtonItem = backItem

            let indexPath = self.tableView.indexPathForSelectedRow!

            SelectedSymbolName = symbolDetailsList[indexPath.row].symbolShortName
        }
    }

    //MARK: Actions

    func performSort(sender: UITapGestureRecognizer) {
        var sortImg: UIImageView
        let identifier = sender.view!.restorationIdentifier!
        if (identifier == UIConstants.lblAmount || identifier == UIConstants.imgSortAmount) {
            sortImg = headerView.imgSortAmount
            switch numberSortCondiiton {
            case .notSorted:
                rotateWithAnimation(sortImg, angle: 0)
                self.numberSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionNumber < $0.transactionNumber
                })
                break
            case .decending:
                rotateWithAnimation(sortImg, angle: M_PI)
                self.numberSortCondiiton = .accending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionNumber > $0.transactionNumber
                })
                break
            case .accending:
                rotateWithAnimation(sortImg, angle: 0)
                self.numberSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionNumber < $0.transactionNumber
                })
                break
            }
        } else if (identifier == UIConstants.lblVolume || identifier == UIConstants.imgSortVolume) {
            sortImg = headerView.imgSortVolume
            switch volumeSortCondiiton {
            case .notSorted:
                rotateWithAnimation(sortImg, angle: 0)
                self.volumeSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionVolume < $0.transactionVolume
                })
                break
            case .decending:
                rotateWithAnimation(sortImg, angle: M_PI)
                self.volumeSortCondiiton = .accending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionVolume > $0.transactionVolume
                })
                break
            case .accending:
                rotateWithAnimation(sortImg, angle: 0)
                self.volumeSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionVolume < $0.transactionVolume
                })
                break
            }
        } else if (identifier == UIConstants.lblSymbol || identifier == UIConstants.imgSortName) {
            sortImg = headerView.imgSortName
            switch symbolSortCondiiton {
            case .notSorted:
                rotateWithAnimation(sortImg, angle: 0)
                self.symbolSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    return persianStringCompare($1.symbolShortName, value2: $0.symbolShortName)
                })
                break
            case .decending:
                rotateWithAnimation(sortImg, angle: M_PI)
                self.symbolSortCondiiton = .accending
                self.symbolDetailsList.sortInPlace({
                    return persianStringCompare($0.symbolShortName, value2: $1.symbolShortName)
                })
                break
            case .accending:
                rotateWithAnimation(sortImg, angle: 0)
                self.symbolSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    return persianStringCompare($1.symbolShortName, value2: $0.symbolShortName)
                })
                break
            }
        }

        self.tableView.reloadData()
    }

    func rotateWithAnimation(target: UIImageView, angle: Double) {
        UIView.animateWithDuration(0.25, animations: {
            target.transform = CGAffineTransformMakeRotation(CGFloat(angle))
        })
    }

    override func updateServiceData() {
        getSymbolListByIndex()
    }


//    func visibleCellsShouldRasterize(aBool:Bool){
//        for cell in tableView.visibleCells as [UITableViewCell]{
//            cell.layer.shouldRasterize = aBool;
//        }
//    }
//    
//    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        isScrolling = false
//        self.visibleCellsShouldRasterize(isScrolling)
//    }
//    
//    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if velocity == CGPointZero{
//            isScrolling = false
//            self.visibleCellsShouldRasterize(isScrolling)
//        }
//    }
//    
//    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        isScrolling = true
//        self.visibleCellsShouldRasterize(isScrolling)
//        
//    }
//    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.layer.shouldRasterize = isScrolling
//    }
}
