//
//  ResultatViewController.swift
//  Demo
//
//  Created by morgan basset on 24/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import RealmSwift

import Darwin
import Foundation

class ResultatViewController: UITableViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    var realmServices = RealmServices()
    
    var services: Array<BusinessService> = Array<BusinessService>()
    
    var exportServices = ExportServices()
    
    var path : URL? = nil
    
    var isImportingFile = false
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urlDocument: URL) {
        //print("The Url is : \(urlDocument)")
        
        //let contentDocument = try String(contentsOf: urlDocument)
        //print("The document content : \(contentDocument)")
        if (isImportingFile) {
            isImportingFile = false
            URLSession.shared.dataTask(with:urlDocument) { (data, response, error) in
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                
                //if let dictionary = json as? [String: Any] {
                //    for (key, value) in dictionary {
                //        // access all key / value pairs in dictionary
                //
                //        //print("key : \(key) , value : \(value)")
                //    }
                //}
                
                do {
                    let jsonModel = try JsonModel(jsonContent: json as! [String: Any])
                    print("jsonModel : \(jsonModel)")
                } catch let serializationError {
                    //in case of unsuccessful deserialization
                    print(serializationError)
                }
                }.resume()
        }
    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("we cancelled document picker")
        isImportingFile = false
        // We have to delete the file from the local repo if it exists
        // path is different of nil if we are creating a file
        // If we cancel the document picker during the selection of a file
        // We have to do nothing and so path will be equal to nil
        if (path != nil) {
            do {
                _ = try String(contentsOf: path!, encoding: String.Encoding.utf8)
                do {
                    try FileManager.default.removeItem(at: path!)
                    path = nil;
                } catch {
                    print("error deleting file at path : " + (path?.absoluteString)!)
                }
            }
            catch {
                path = nil
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController) {
        print("we cancelled document menu")
        isImportingFile = false
        // We have to delete the file from the local repo if it exists
        // path is different of nil if we are creating a file
        // If we cancel the document picker during the selection of a file
        // We have to do nothing and so path will be equal to nil
        if (path != nil) {
            do {
                _ = try String(contentsOf: path!, encoding: String.Encoding.utf8)
                do {
                    try FileManager.default.removeItem(at: path!)
                    path = nil;
                } catch {
                    print("error deleting file at path : " + (path?.absoluteString)!)
                }
            }
            catch {
                path = nil
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
       // self.refreshServicesArray()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func refreshServicesArray(){
        self.services = self.realmServices.getBusinessServicesArray()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        self.refreshServicesArray()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let export = UITableViewRowAction(style: .normal, title: "Export to Drive") { action, index in
            print("share button tapped")
            print(self.exportServices.getSubscribersJSON(_businessServiceTitle: self.services[editActionsForRowAt.row].title))
        }
        export.backgroundColor = .blue
        
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .orange
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            print(self.services[editActionsForRowAt.row])
            // Delete BusinessService from DataBase
            self.realmServices.deleteBusinessService(_title: self.services[editActionsForRowAt.row].title)
            // Refresh 'services' variable
            self.refreshServicesArray()
            // Delete Row in TableView
            tableView.deleteRows(at: [editActionsForRowAt], with: .automatic)
        }
        delete.backgroundColor = .red
        
        return [delete, more, export]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CustomCell", owner: self, options: nil)?.first as! CustomCell
        
        let row = indexPath.row
        
        cell.textLabel?.text = services[row].title
        cell.detailTextLabel?.text = String(services[row].subscribers.count)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("tap on cell \(indexPath.row)")
        //let viewController = storyboard?.instantiateViewController(withIdentifier: "SubscribersTableView") as! SubscribersTableViewController
        //viewController.toPrint = services[indexPath.row].title
        //navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    
}
