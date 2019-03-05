//
//  ViewController.swift
//  example1
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 th.ac.kmutnb.www. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    @IBAction func appStartBtn(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! appStartViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    @IBAction func feedbackBtn(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedBackPopUpID") as! feedBackViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @IBOutlet weak var dateTF: UILabel!
    @IBOutlet weak var locationTF: UILabel!
    @IBOutlet weak var productTF: UILabel!
    @IBOutlet weak var goodTF: UILabel!
    @IBOutlet weak var wellTF: UILabel!
    @IBOutlet weak var badTF: UILabel!
    let fileName = "dbExam2.sqlite"
    let fileManager = FileManager.default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    var dateRef = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(startApp(not:)), name: NSNotification.Name(rawValue: "confirmStartNoti"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(not:)), name: NSNotification.Name(rawValue: "confirmGood"), object: nil)
        
        let dbURL = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(fileName)
        let openDb = sqlite3_open(dbURL.path, &self.db)
        if openDb != SQLITE_OK {
            print("Opening Database Error!")
            return
        }
        let sql = "CREATE TABLE IF NOT EXISTS evaluation " +
            "(id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "date TEXT, " +
            "location TEXT, " +
            "product TEXT, " +
            "good TEXT, " +
            "well TEXT, " +
            "bad TEXT)"
        let createTb = sqlite3_exec(self.db, sql, nil, nil, nil)
        if createTb != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            print("err createTb = \(err)")
        }
    }
    @objc func startApp(not: Notification) {
        if let data = not.userInfo {
            // Safely unwrap the name sent out by the notification sender
            if let date = data["date"] as? NSString, let location = data["location"] as? NSString, let product = data["product"] as? NSString{
                var good = NSString()
                good = "0"
                var well = NSString()
                well = "0"
                var bad = NSString()
                bad = "0"
                if (location == "" || product == "") {
                    print("TRUEEEEE")
                    self.fetchData(date: date as String)
                } else {
                    print("FALSEEEEE")
                    self.sql = "INSERT INTO evaluation VALUES (null, ?, ?, ?, ?, ?, ?)"
                    sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
                    sqlite3_bind_text(self.stmt, 1, date.utf8String, -1, nil)
                    sqlite3_bind_text(self.stmt, 2, location.utf8String, -1, nil)
                    sqlite3_bind_text(self.stmt, 3, product.utf8String, -1, nil)
                    sqlite3_bind_text(self.stmt, 4, good.utf8String, -1, nil)
                    sqlite3_bind_text(self.stmt, 5, well.utf8String, -1, nil)
                    sqlite3_bind_text(self.stmt, 6, bad.utf8String, -1, nil)
                    sqlite3_step(self.stmt)
                    
                    self.fetchData(date: date as String)
                }
            }
        }
    }
    func fetchData(date: String) {
        print("date: \(date)")
        sql = "SELECT * FROM evaluation WHERE date=\"\(date)\""
        print("sql: \(sql)")
        sqlite3_prepare(db, sql, -1, &pointer, nil)
        var date: String
        var location: String
        var product: String
        var good: String
        var well: String
        var bad: String
        
        while(sqlite3_step(pointer) == SQLITE_ROW) {
            
            date = String(cString: sqlite3_column_text(pointer, 1))
            dateTF.text = ("DATE: \(date)\n")
            dateRef = date
            
            location = String(cString: sqlite3_column_text(pointer, 2))
            locationTF.text = ("LOCATION: \(location)\n")
            
            product = String(cString: sqlite3_column_text(pointer, 3))
            productTF.text = ("PRODUCT: \(product)\n")
            
            good = String(cString: sqlite3_column_text(pointer, 4))
            print("good \(good)")
            goodTF.text = good
            
            well = String(cString: sqlite3_column_text(pointer, 5))
            wellTF.text = well
            
            bad = String(cString: sqlite3_column_text(pointer, 6))
            badTF.text = bad
        }
    }
    @objc func updateData(not: Notification) {
        if let data = not.userInfo {
            // Safely unwrap the name sent out by the notification sender
            if let select = data["select"] as? NSString{
                print("select : \(select)")
                if (select == "good") {
                    let oldGood = goodTF.text!
                    let new = Int(oldGood)! + 1
                    let sql = "UPDATE evaluation SET good=\'\(new)\' WHERE date=\'\(dateRef)\';"
                    sqlite3_exec(self.db, sql, nil, nil, nil)
                    self.fetchData(date: dateRef as String)
                }
                if (select == "well") {
                    let oldGood = wellTF.text!
                    let new = Int(oldGood)! + 1
                    let sql = "UPDATE evaluation SET well=\'\(new)\' WHERE date=\'\(dateRef)\';"
                    sqlite3_exec(self.db, sql, nil, nil, nil)
                    self.fetchData(date: dateRef as String)
                }
                if (select == "bad") {
                    let oldGood = badTF.text!
                    let new = Int(oldGood)! + 1
                    let sql = "UPDATE evaluation SET bad=\'\(new)\' WHERE date=\'\(dateRef)\';"
                    sqlite3_exec(self.db, sql, nil, nil, nil)
                    self.fetchData(date: dateRef as String)
                }
            }
        }
    }

}

