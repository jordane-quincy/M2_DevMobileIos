//
//  InfoSystemViewController.swift
//  Demo
//
//  Created by MAC ISTV on 14/05/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class InfoSystemViewController: UIViewController {

    var customNavigationController: UINavigationController? = nil
    var scheduledFunction:Timer? = nil
    var labelSystemCpu = UILabel(frame: CGRect(x: 20, y: 100, width: 335, height: 20))
    var labelUserCpu = UILabel(frame: CGRect(x: 20, y: 120, width: 335, height: 20))
    var labelIdleCpu = UILabel(frame: CGRect(x: 20, y: 140, width: 335, height: 20))
    var labelNiceCpu = UILabel(frame: CGRect(x: 20, y: 160, width: 335, height: 20))
    var labelPhysicalMemory = UILabel(frame: CGRect(x: 20, y: 220, width: 335, height: 20))
    var labelFreeMemory = UILabel(frame: CGRect(x: 20, y: 240, width: 335, height: 20))
    var labelWiredMemory = UILabel(frame: CGRect(x: 20, y: 260, width: 335, height: 20))
    var labelActiveMemory = UILabel(frame: CGRect(x: 20, y: 280, width: 335, height: 20))
    var labelInactiveMemory = UILabel(frame: CGRect(x: 20, y: 300, width: 335, height: 20))
    var labelCompressedMemory = UILabel(frame: CGRect(x: 20, y: 320, width: 335, height: 20))
    var sys = System()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Infos Système"
        
        
        // Setup base interface
        let CPULabel = UILabel(frame: CGRect(x: 20, y: 70, width: 335, height: 20))
        CPULabel.text = "CPU : "
        self.view.addSubview(CPULabel)
        labelSystemCpu.text = "% CPU System :"
        self.view.addSubview(labelSystemCpu)
        labelUserCpu.text = "% CPU User :"
        self.view.addSubview(labelUserCpu)
        labelIdleCpu.text = "% CPU non utilisé :"
        self.view.addSubview(labelIdleCpu)
        labelNiceCpu.text = "% CPU actions non prioritaires :"
        self.view.addSubview(labelNiceCpu)
        
        let memoryLabel = UILabel(frame: CGRect(x: 20, y: 190, width: 335, height: 20))
        memoryLabel.text = "Mémoire :"
        self.view.addSubview(memoryLabel)
        labelPhysicalMemory.text = "Taille mémoire :"
        self.view.addSubview(labelPhysicalMemory)
        labelFreeMemory.text = "Mémoire libre :"
        self.view.addSubview(labelFreeMemory)
        labelWiredMemory.text = "Wired Memory :"
        self.view.addSubview(labelWiredMemory)
        labelActiveMemory.text = "Mémoire Active :"
        self.view.addSubview(labelActiveMemory)
        labelInactiveMemory.text = "Mémoire Inactive :"
        self.view.addSubview(labelInactiveMemory)
        labelCompressedMemory.text = "Mémoire Compréssée :"
        self.view.addSubview(labelCompressedMemory)
        
        
        self.displaySystemInfo()
        scheduledFunction = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(InfoSystemViewController.displaySystemInfo), userInfo: nil, repeats: true)
    }
    
    func displaySystemInfo() {
        let cpuUsage = sys.usageCPU()
        
        labelSystemCpu.text = "Usage CPU System : " + String(Double(round(10000*cpuUsage.system)/10000)) + "%"
        labelUserCpu.text = "Usage CPU User : " + String(Double(round(10000*cpuUsage.user)/10000)) + "%"
        labelIdleCpu.text = "% CPU non utilisé : " + String(Double(round(10000*cpuUsage.idle)/10000)) + "%"
        labelNiceCpu.text = "% CPU actions non prioritaires : " + String(Double(round(10000*cpuUsage.nice)/10000)) + "%"
        
        labelPhysicalMemory.text = "Taille mémoire : " + String(System.physicalMemory()) + "GB"
        
        var memoryUsage = System.memoryUsage()
        func memoryUnit(_ value: Double) -> String {
            if value < 1.0 { return String(Int(value * 1000.0))    + "MB" }
            else           { return NSString(format:"%.2f", value) as String + "GB" }
        }
        
        labelFreeMemory.text = "Mémoire libre : " + String(memoryUnit(memoryUsage.free))
        labelWiredMemory.text = "Wired Memory : " + String(memoryUnit(memoryUsage.wired))
        labelActiveMemory.text = "Mémoire Active : " + String(memoryUnit(memoryUsage.active))
        labelInactiveMemory.text = "Mémoire Inactive : " + String(memoryUnit(memoryUsage.inactive))
        labelCompressedMemory.text = "Mémoire Compréssée : " + String(memoryUnit(memoryUsage.compressed))
    }
    
    public func setupNavigationController(navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    override func willMove(toParentViewController: UIViewController?)
    {
        if (toParentViewController == nil) {
            // Stop scheduled function
            self.scheduledFunction?.invalidate()
            // Hide the navigation bar
            self.customNavigationController?.setNavigationBarHidden(true, animated: true)
        }
    }


}
