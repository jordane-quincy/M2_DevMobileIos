//
//  ResultatPersonTableView.swift
//  Demo
//
//  Created by MAC ISTV on 10/05/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class ResultatPersonTableView: UITableViewController {
    
    var realmServices = RealmServices()
    
    var customNavigationController: UINavigationController? = nil

    var affiliates: Array<Person> = Array<Person>()
    
    public func setupNavigationController(navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    public func setupAffiliates(affiliates: Array<Person>) {
        self.affiliates = affiliates
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Liste affiliés"
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    }
    
    override func willMove(toParentViewController: UIViewController?)
    {
        if (toParentViewController == nil) {
            // Back to parent
            self.customNavigationController?.setNavigationBarHidden(true, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.refreshServicesArray()
        //self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.affiliates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CustomCell", owner: self, options: nil)?.first as! CustomCell
        
        let row = indexPath.row
        
        cell.textLabel?.text = self.affiliates[row].getDefaultFirstAndLastName()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Supprimer") { action, index in
            print("delete button tapped")
            print(self.affiliates[editActionsForRowAt.row])
            // Delete BusinessService from DataBase
            self.realmServices.deleteSubcriber(id: self.affiliates[editActionsForRowAt.row].id)
            // Refresh 'services' variable
            //self.refreshServicesArray()
            // Delete Row in TableView
            self.affiliates.remove(at: editActionsForRowAt.row)
            tableView.deleteRows(at: [editActionsForRowAt], with: .automatic)
        }
        delete.backgroundColor = .red
        
        return [delete]
    }

    
    
    // method when we tap on a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap on cell \(indexPath.row)")
        
        // go to the detail of the person
        let resultatPersonDetails = ResultatPersonDetails(nibName: "ResultatPersonDetails", bundle: nil)
        resultatPersonDetails.setupAffiliate(affiliate: self.affiliates[indexPath.row])
        resultatPersonDetails.setupNavigationController(navigationController: self.customNavigationController!)
        self.customNavigationController?.pushViewController(resultatPersonDetails, animated: true)
    }
}
