//
//  BaseViewController.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
    }
    
    func setupNavbar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow_back_nav_bar"), style: .plain, target: self, action: #selector(didTouchBackButton(sender:)))
        navigationItem.leftBarButtonItems = [backButton]
    }
    
    @objc func didTouchBackButton(sender _: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showLoading() {
        ViewControllerUtils.shared.showActivityIndicator(uiView: self.view)
    }
    
    func hideLoading() {
        ViewControllerUtils.shared.hideActivityIndicator()
    }
}
