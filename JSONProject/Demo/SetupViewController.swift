//
//  SetupViewController.swift
//  Demo
//
//  Created by morgan basset on 03/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import RealmSwift

class SetupViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var controllerArray = [UIViewController]()
    var pX = 20
    var scrollView = UIScrollView()
    var containerView = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh services to select
        self.resetServicesToSelect()
        self.addSelectService()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = view.bounds
        self.containerView.frame = CGRect(x: 0, y: 0, width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        self.containerView = UIView()
        self.scrollView.addSubview(self.containerView)

        // setup swipe
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        
        // Import json
        let importLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 30.00))
        self.pX += 40
        importLabel.text = "Importer un service : "
        self.containerView.addSubview(importLabel)
        let importButton = UIButton(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 30.00))
        self.pX += 40
        importButton.setTitle("Selectionner le fichier", for: .normal)
        importButton.backgroundColor = UIColor.blue
        importButton.addTarget(self, action: #selector(self.selectFile(_:)), for: .touchUpInside)
        self.containerView.addSubview(importButton)
        
        // Select service already created
        let selectServiceLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 30.00))
        selectServiceLabel.text = "Charger un service existant :"
        self.containerView.addSubview(selectServiceLabel)
        self.pX += 40
        addSelectService()
    }
    
    // swipe function
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                // GO TO THE LEFT Pannel
                DispatchQueue.main.async() {
                    self.tabBarController?.selectedIndex = 1
                }
            case UISwipeGestureRecognizerDirection.left:
                // GO TO THE RIGHT Pannel
                DispatchQueue.main.async() {
                    self.tabBarController?.selectedIndex = 3
                }
            default:
                break
            }
        }
    }
    
    public func addSelectService() {
        // Affichage des Services qu'on peut charger !!
        let realmServices = RealmServices()
        let allServices = realmServices.getBusinessServicesArray()
        if (allServices.count == 0) {
            let message = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 30.00))
            message.tag = 1
            message.text = "Aucun service en base"
            self.pX += 40
            self.containerView.addSubview(message)
        }
        for businessService in allServices {
            // TODO display all services as button
            let buttonService = UIButton(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 30.00))
            self.pX += 40
            buttonService.setTitle(businessService.title, for: .normal)
            buttonService.tag = 1
            buttonService.backgroundColor = UIColor.blue
            buttonService.addTarget(self, action: #selector(self.loadService(_:)), for: .touchUpInside)
            self.containerView.addSubview(buttonService)
        }
        self.scrollView.contentSize = CGSize(width: 375, height: self.pX + 100)
    }
    
    func selectFile(_ sender: UIButton) {
        // Code pour récupérer file depuis iCloud
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text"], in: .import)
        importMenu.delegate = self
        present(importMenu, animated: true, completion: nil)
        // code pour le browser sur le repo de l'app
        //let fileBrowser = FileBrowser();
        //present(fileBrowser, animated: true, completion: nil)
    }
    
    public func resetServicesToSelect() {
        for view in self.containerView.subviews {
            if (view.tag == 1) {
                view.removeFromSuperview()
                self.pX -= 40
            }
        }
    }
    
    public func loadService(_ sender: UIButton) {
        let title = sender.title(for: .normal)
        let realmServices = RealmServices()
        let businessServiceToLoad = realmServices.getBusinessService(_title: title!)
        let jsonModelData = businessServiceToLoad.jsonModelInString.data(using: .utf8)
        let json = try? JSONSerialization.jsonObject(with: jsonModelData!, options: [])
        do {
            let jsonModel = try JsonModel(jsonContent: json as! [String: Any])
            
            DispatchQueue.main.async() {
                self.tabBarController?.selectedIndex = 0
            }
            let myVC1 = self.tabBarController?.viewControllers![0] as! AccueilViewController
            // create interface
            myVC1.createViewFromJson(json: jsonModel)
            
            // Set up last Used Service
            realmServices.resetlastUsedService()
            realmServices.setIsLastUsedForService(title: title!)
            
        } catch let serializationError {
            //in case of unsuccessful deserialization
            print(serializationError)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urlDocument: URL) {
        //print("The Url is : \(urlDocument)")
        
        
        //let contentDocument = try String(contentsOf: urlDocument)
        //print("The document content : \(contentDocument)")
        
        URLSession.shared.dataTask(with:urlDocument) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            do {
                let jsonModel = try JsonModel(jsonContent: json as! [String: Any])
                
                DispatchQueue.main.async() {
                    self.tabBarController?.selectedIndex = 0
                }
                let myVC1 = self.tabBarController?.viewControllers![0] as! AccueilViewController
                // create interface
                myVC1.createViewFromJson(json: jsonModel)
                
                // create the service in dataBase
                let realmServices = RealmServices()
                realmServices.resetlastUsedService()
                let jsonModelInString = String(data: data!, encoding: .utf8)
                let businessService = BusinessService(_title: (jsonModel?.title)!, _serviceDescription: (jsonModel?.description)!, icon: jsonModel?.icon ?? "", jsonModelInString: jsonModelInString!, isLastUsed: true)
                
                // on ajoute les options au service pour l'export
                for offer in (jsonModel?.offers)! {
                    for option in offer.features {
                        // verify if the option is not already set
                        var optionNotSet = true
                        for _option in businessService.listOfOptions {
                            if (_option.label == option.title) {
                                optionNotSet = false
                            }
                        }
                        if (optionNotSet) {
                            let optionLabel = OptionLabel(label: option.title)
                            businessService.listOfOptions.append(optionLabel)
                        }
                    }
                }
                
                // On vérifie si le service n'existe pas déjà en database
                if (realmServices.serviceFree(title: businessService.title)) {
                    realmServices.createBusinessService(businessService: businessService)
                }
                else {
                    realmServices.setIsLastUsedForService(title: businessService.title)
                }
            } catch let serializationError {
                //in case of unsuccessful deserialization
                print(serializationError)
            }
            
            
            }.resume()
            
        
    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("we cancelled")
        dismiss(animated: true, completion: nil)
        
    }
}
