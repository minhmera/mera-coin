//
//  ViewControllerUtils.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import UIKit


class ViewControllerUtils {
    static let shared = ViewControllerUtils()

    var container: UIView = UIView()
    var dimview: UIView = UIView()
    var backgroundButton: UIButton = UIButton()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func showActivityIndicator(uiView: UIView, isAllowTabOutSideToClose: Bool = true) {
        uiView.addSubview(dimview)
        loadingView.addSubview(activityIndicator)
        container.addSubview(backgroundButton)
        container.addSubview(loadingView)
        uiView.addSubview(container)

        container.frame = uiView.frame
        backgroundButton.frame = container.frame
        dimview.frame = uiView.frame

        container.center = uiView.center
        dimview.center = uiView.center

        container.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimview.backgroundColor = UIColor.black.withAlphaComponent(0.25)

        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 20

        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        if isAllowTabOutSideToClose == true {
            backgroundButton.addTarget(self, action: #selector(onBackgroudClicked), for: .touchUpInside)
        }
        
        activityIndicator.startAnimating()
    }
    
    @objc func onBackgroudClicked(sender: UIButton!) {
        hideActivityIndicator()
    }

    /*
     Hide activity indicator
     */
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        dimview.removeFromSuperview()
    }
}

