//
//  ViewController.swift
//  FirabaseDatabase
//
//  Created by Megha on 29/04/18.
//  Copyright © 2018 com.parmar. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    var ref : DatabaseReference!
    var handle : DatabaseHandle?
    var arrData :[String] = []
    
    let indexMessage :Int? = nil
    
    @IBOutlet var tblMainVC: UITableView!
    @IBAction func btnSavePress(_ sender: Any) {

        if txtName.text != "" {
        ref.child("Database").childByAutoId().setValue(self.txtName.text)
        }
        self.txtName.text = ""
    }
    @IBOutlet var txtName: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        handle = ref.child("Database").observe(.childAdded, with: { (screenshot) in
           if let item = screenshot.value as? String {
                self.arrData.append(item)
                self.tblMainVC.reloadData()
            }
        })
    }
}
extension ViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! Cell
        cell.lblTitle.text = self.arrData[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            ref.observe(.childRemoved, with: { (snapshot) -> Void in
                let index = indexPath.row
                 let intno =   snapshot.childrenCount
                self.arrData.remove(at: index)
                self.tblMainVC.deleteRows(at: [IndexPath(row: index, section:0)], with: UITableViewRowAnimation.automatic)
            })
            
        }
        
        
       
    }
    
}

