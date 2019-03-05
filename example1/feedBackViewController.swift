//
//  feedBackViewController.swift
//  example1
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 th.ac.kmutnb.www. All rights reserved.
//

import UIKit

class feedBackViewController: UIViewController {

    @IBAction func Gbtn(_ sender: Any) {
        self.removeAnimate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "confirmGood"), object: self, userInfo: ["select": "good"])
        self.view.removeFromSuperview()
    }
    @IBAction func Wbtn(_ sender: Any) {
        self.removeAnimate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "confirmGood"), object: self, userInfo: ["select": "well"])
        self.view.removeFromSuperview()
    }
    @IBAction func BBtn(_ sender: Any) {
        self.removeAnimate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "confirmGood"), object: self, userInfo: ["select": "bad"])
        self.view.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(appStartViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()


        // Do any additional setup after loading the view.
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}
