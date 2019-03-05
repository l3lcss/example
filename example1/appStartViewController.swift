//
//  appStartViewController.swift
//  example1
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 th.ac.kmutnb.www. All rights reserved.
//

import UIKit

class appStartViewController: UIViewController {

    @IBAction func confirmStart(_ sender: Any) {
        let date = (self.dateTF.text! as NSString) as String
        let location = (self.locationTF.text! as NSString) as String
        let product = (self.productTF.text! as NSString) as String
        self.removeAnimate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "confirmStartNoti"), object: self, userInfo: ["date": date, "location": location, "product": product])
        self.view.removeFromSuperview()
        
    }
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var productTF: UITextField!
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action:
            #selector(appStartViewController.dateChange(datePicker:)),
                              for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(appStartViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        dateTF.inputView = datePicker
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()

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
    @objc func dateChange(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTF.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}
