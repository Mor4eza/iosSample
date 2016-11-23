//
//  AboutUsViewController.swift
//  SabadBan
//
//  Created by PC22 on 9/11/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Localize_Swift

class AboutUsViewController: BaseViewController {

    //MARK: Properties

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var updateIntervalNoticeLabel: UILabel!
    @IBOutlet weak var allRightsReserevedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = Strings.AboutUs.localized()
        versionLabel.text = "\(Strings.Version.localized()) \(String(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String))"

        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierPersian)
        let currentDayInt = (calendar?.component(NSCalendarUnit.Day, fromDate: buildDate))!
        let currentMonthInt = (calendar?.component(NSCalendarUnit.Month, fromDate: buildDate))!
        let currentYearInt = (calendar?.component(NSCalendarUnit.Year, fromDate: buildDate))!
        let currentHourInt = (calendar?.component(NSCalendarUnit.Hour, fromDate: buildDate))!
        let currentMinuteInt = (calendar?.component(NSCalendarUnit.Minute, fromDate: buildDate))!

        releaseDateLabel.text = "\(Strings.ReleaseDate.localized()) \(currentHourInt.addZero()):\(currentMinuteInt.addZero()) \(currentDayInt.addZero())-\(currentMonthInt.addZero())-\(currentYearInt)"
        updateIntervalNoticeLabel.text = Strings.UpdateDataIntervalNotice.localized()
        allRightsReserevedLabel.text = Strings.AllrightsReserved.localized()
    }

    deinit {

        debugPrint("Deinit------------------------>>>>>")
    }
}
