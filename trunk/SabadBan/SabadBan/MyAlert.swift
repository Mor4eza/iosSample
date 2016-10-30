//
//  MyAlert.swift
//  M-TraderPro
//
//  Created by Morteza Gharedaghi on 8/24/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit

protocol DialogClickDelegate {
    func dialogOkButtonClicked()

    func dialogCancelButtonClicked()

}

class MyAlert: UIView {

    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var lblDetails: UILabel!

    @IBOutlet weak var lblRight: UIButton!

    @IBOutlet weak var lblLeft: UIButton!
    var delegate: DialogClickDelegate!
    var canDismissWithTouch: Bool!
    var view: UIView!

    @IBOutlet weak var visualEffectView: UIView!

    @IBOutlet weak var rightConstrator: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    /**
     Initialiser methodb

     - parameter aDecoder: aDecoder
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    /**
     Loads a view instance from the xib file

     - returns: loaded view
     */
    func loadViewFromXibFile() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: UIConstants.MyAlert, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    func setupView() {
        view = loadViewFromXibFile()
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        self.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 4.0
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSizeMake(0.0, 8.0)
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        self.addSubview(blurredEffectView)
        visualEffectView.layer.cornerRadius = 4.0
        lblLeft.showsTouchWhenHighlighted = true
        lblRight.showsTouchWhenHighlighted = true
        lblDetails.changeDirection()
    }

    /**
     Displays the overlayView on the passed in view

     - parameter onView: the view that will display the overlayView
     */

    func showAlert(title: String, details: String, okTitle: String, cancelTitle: String, onView: UIView) {
        self.lblTitle.text = title
        self.lblDetails.text = details
        self.lblRight.setTitle(okTitle, forState: .Normal)
        self.lblLeft.setTitle(cancelTitle, forState: .Normal)
        self.lblDetails.sizeToFit()
        if cancelTitle.isEmpty {
            lblLeft.hidden = true
            lblLeft.removeConstraints(lblLeft.constraints)
            rightConstrator.constant = -27
            self.view.layoutIfNeeded()
            lblLeft.translatesAutoresizingMaskIntoConstraints = false
            lblRight.translatesAutoresizingMaskIntoConstraints = false
        }

        lblDetails.lineBreakMode = .ByWordWrapping
        lblDetails.numberOfLines = 0
        lblDetails.sizeToFit()

        if okTitle.isEmpty {
            return
        }
        displayView(onView)
    }

    func displayView(onView: UIView) {
        self.alpha = 0.0
        onView.addSubview(self)

        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: onView, attribute: .CenterY, multiplier: 1.0, constant: -30.0)) // move it a bit upwards
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: onView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        onView.needsUpdateConstraints()

        // display the view
        transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(0.3, animations: {
            () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransformIdentity
        }) {
            (finished) -> Void in
            // When finished wait 1.5 seconds, than hide it
//            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
//            dispatch_after(delayTime, dispatch_get_main_queue()) {
//                self.hideView()
//            }
        }
    }

    /**
     Updates constraints for the view. Specifies the height and width for the view
     */
    override func updateConstraints() {
        super.updateConstraints()

        addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 240))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 240))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
    }

    /**
     Hides the view with animation
     */
    private func hideView() {
        UIView.animateWithDuration(0.3, animations: {
            () -> Void in
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) {
            (finished) -> Void in
            self.removeFromSuperview()
        }
    }

    /**
     Butoon Actions
    */

    @IBAction func rightClick(sender: AnyObject) {

        debugPrint("Right")
        if self.delegate != nil {
            delegate.dialogOkButtonClicked()
        }
        self.hideView()
    }

    @IBAction func leftClick(sender: AnyObject) {
        debugPrint("Left")
        if self.delegate != nil {
            delegate.dialogCancelButtonClicked()
        }
        self.hideView()

    }

}
