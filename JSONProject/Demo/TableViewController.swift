//
//  TableViewController.swift
//  Demo
//
//  Created by MAC ISTV on 24/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var menuItems = MenuItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.names.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = menuItems.names[row]
        let price = String(format: "%2.2f", menuItems.prices[row])
        cell.detailTextLabel?.text = price
        if (menuItems.specials[row]) {
            cell.backgroundColor = UIColor.green
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
}
