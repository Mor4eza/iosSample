//
//  LoadingOverlay.swift
//  app
//
//  Created by Igor de Oliveira Sa on 25/03/15.
//  Copyright (c) 2015 Igor de Oliveira Sa. All rights reserved.
//
//  Usage:
//
//  # Show Overlay
//  LoadingOverlay.shared.showOverlay(self.navigationController?.view)
//
//  # Hide Overlay
//  LoadingOverlay.shared.hideOverlayView()

import UIKit
import Foundation


public class LoadingOverlay {

    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var isShown = Bool()

    class var shared: LoadingOverlay {

        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }

        return Static.instance
    }

    public func showOverlay(view: UIView!) {
        if !isShown {
            overlayView = UIView(frame: UIScreen.mainScreen().bounds)
            overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            activityIndicator.center = overlayView.center
            overlayView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            view.addSubview(overlayView)
            isShown = true
        }
    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        isShown = false
    }
}