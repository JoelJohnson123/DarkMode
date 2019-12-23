//  AppDelegate.swift
//  Switch Appearence

//  Joel Johnson on 12/17/18
//  Copyright © 2018 Joel Johnson. All rights reserved.

import Cocoa
import Foundation // allows running applescripts from cocoa applications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // creates menu bar item
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    // initialize on app launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("Image"))
            
            // determine if system is in light or dark mode
            let out = shell(lPath: "/bin/bash", args:["-c", "defaults read -g AppleInterfaceStyle"])
            print(out)
            
            var lightSetting: String = ""
            
            if out.contains("Dark") {
                lightSetting = "Toggle Light Mode"
            }
            else {
                lightSetting = "Toggle Dark Mode"
            }
            constructMenu(sysSetting: lightSetting) // calls function to build menu
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
 
    // function that switches dark/light mode
    // @objc prepares function for objective-c runtime at compilation
    @objc func switch_mode(_ sender: NSMenuItem) {
        let task = Process();
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["/Users/Joel/Switch Appearence/Switch Appearence/ToggleDarkMode.scpt"]
        task.launch()
        
        // toggle item title
        if sender.title == "Toggle Dark Mode" {
            sender.title = "Toggle Light Mode"
            sender.keyEquivalent = "l"
        }
        else {
            sender.title = "Toggle Dark Mode"
            sender.keyEquivalent = "d"
        }
    }
    
    // function that switches app exemptions for dark mode
    @objc func switch_app(_ sender: NSMenuItem) {
        // unwrap appInfo attribute
        let info = sender.representedObject as! appInfo // ! asserts that optional atrribute is not nil
        
        // not exempt from dark mode OS setting, make exempt and set attributes
        if !info.exempt {
            // _ = ignores non-void return value
            _ = shell(lPath: "/bin/bash", args:["-c", "defaults write \(info.bundleID) NSRequiresAquaSystemAppearance -bool YES"])
            info.exempt = true
            sender.state = NSControl.StateValue.on
        }
        else if info.exempt {
            // user delete instead of write -bool NO so that app conforms to global system setting
            _ = shell(lPath: "/bin/bash", args:["-c", "defaults delete \(info.bundleID) NSRequiresAquaSystemAppearance"])
            info.exempt = false
            sender.state = NSControl.StateValue.off
        }
    }
    
    
    
    // builds menu items
    func constructMenu(sysSetting: String) {
        // checks current system appearence
        // var cur_appearence = NSAppearance * appearance
    
        let menu = NSMenu() // menu object
        
        // keyEquivalent specffifies key command, lowercase used cmd, uppercase uses cmd + shift
        //menu.addItem(NSMenuItem(title: "✔ Light Mode", action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: "l"))
        var key = ""
        if sysSetting == "Toggle Light Mode" { key = "l" }
        else { key = "d" }
        menu.addItem(NSMenuItem(title: sysSetting, action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: key))
        menu.addItem(NSMenuItem.separator())
        
        // set target and action to nil grays out menu item
        let exemptionHeader = NSMenuItem(title: "Apps always in light mode:", action: nil, keyEquivalent: "")
        exemptionHeader.target = nil
        menu.addItem(exemptionHeader)
        
        let appList = buildAppList()
        
        // keeps list of all appInfo objects
        var allAppInfos: [appInfo] = []
        for app in appList {
    
            let appName = bundleIDFor(appName: app)
            let exempt = lightStatus(bundleID: appName)
            
            // create object of appInfo with args, connected to NSNenuItem
            let data = appInfo(name: app, bundleID: appName, exempt: exempt)
            allAppInfos.append(data)
            
            let item = NSMenuItem(title: app.replacingOccurrences(of: ".app", with: ""),
                                  action: nil,
                                  keyEquivalent: "")
            item.representedObject = data
            item.action = #selector(AppDelegate.switch_app(_:))
            
            
            // if app is exempt from dark mode, put checkmark next to menu item
            if exempt { item.state = NSControl.StateValue.on }
            
            let swiftIcon = NSWorkspace.shared.icon(forFile: "/Applications/\(app)")
            // force icon size to 18x18
            swiftIcon.size = CGSize(width: 20.0, height: 20.0)
            print(swiftIcon)
            /*if !swiftIcon {
                print("\(app) is null")
                break
            }*/
        
            /*
            for icon in swiftIcon {
                print(icon)
            }*/
            item.image = swiftIcon
            
            menu.addItem(item)
            
        }
        
        for app in allAppInfos {
            print("\(app.name) --> \(app.bundleID) --> \(app.exempt)")
        }
    
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
    }
}
