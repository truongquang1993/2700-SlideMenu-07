//
//  ViewController.swift
//  2700 SlideMenu 06
//
//  Created by Trương Quang on 7/10/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let passDataMain = Notification.Name(rawValue: "passDataMain")
    static let passDataMenu = Notification.Name(rawValue: "passDataMenu")
}

class ViewController: UIViewController, ViewControllerMainDelegate {
    
    @IBOutlet weak var showMenu: UIButton!
    @IBOutlet weak var leadingSideMenu: NSLayoutConstraint!
    @IBOutlet weak var containerViewMenu: UIView! {
        didSet {
            containerViewMenu.dropShadow()
        }
    }
    
    var showing = false {
        didSet {
            UIView.animate(withDuration: 0.35
                , animations: {
                    self.leadingSideMenu.constant = self.showing ? 0 : -self.containerViewMenu.bounds.width
                    self.showMenu.alpha = self.showing ? 0.5 : 0
                    self.containerViewMenu.layer.masksToBounds = false
                    self.view.layoutIfNeeded()
            }) { (isSuccess) in
                if !self.showing {
                    self.containerViewMenu.layer.masksToBounds = true
                }
            }

        }
    }
    
    var infor: Infor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.layoutIfNeeded()
        showing = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(addphoto), name: .passDataMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addphoto), name: .passDataMain, object: nil)
        
    }
    
    deinit {
    }
    
    @objc func addphoto(notification: Notification) {
        let recInfor = notification.object as! Infor
        infor = recInfor
    }
    
    @IBAction func getOutMenu(_ sender: Any) {
        showing = !showing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let vcMain = navigation.topViewController as? ViewControllerMain {
                vcMain.delegate = self
            }
        }
    }
    
}

extension UIView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 3, height: 1)
        self.layer.shadowRadius = 5
    }
}
