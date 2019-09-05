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
            button.image = NSImage(named:NSImage.Name("Icon"))
            constructMenu() // calls function to build menu
            
            // determine if system is in light or dark mode
            let out = shell(lPath: "/bin/bash", args:["-c", "defaults read -g AppleInterfaceStyle"])
            print(out)
            if out.contains("Dark") {
                print("System is in dark mode")
            }
            else {
                print("system is in light mode")
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    // function that switches dark/light mode
    @objc func switch_mode(_ sender: Any?) {
        let task = Process();
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["/Users/Joel/Switch Appearence/Switch Appearence/ToggleDarkMode.scpt"]
        task.launch()
        
    }
    
    // generates list of installed .apps from /applications
    func buildAppList() -> Array<String> {
        // list of bundle ID's from apple apps
        let macosApps = ["com.apple.AppStore", "com.apple.iBooksX", "com.apple.calculator", "com.apple.iCal",
                        "com.apple.AddressBook", "com.apple.dashboardlauncher", "com.apple.Dictionary",
                        "com.apple.FaceTime", "com.apple.FontBook", "com.apple.iWork.Keynote", "com.apple.mail",
                        "com.apple.Image_Capture", "com.apple.Maps", "com.apple.iChat", "com.apple.Notes", "com.apple.news",
                        "com.apple.iWork.Numbers", "com.apple.iWork.Pages", "com.apple.PhotoBooth", "com.apple.Photos",
                        "com.apple.Preview", "com.apple.QuickTimePlayerX", "com.apple.reminders", "com.apple.Safari",
                        "com.apple.stocks", "com.apple.systempreferences", "com.apple.TextEdit", "com.apple.VoiceMemos",
                        "com.apple.iMovieApp", "com.apple.iTunes"]
        
        print(macosApps)
        return macosApps
        
    }
    
    // returns output of bash commands
    func shell(lPath: String, args: [String]) -> String {
        let task = Process()
        task.launchPath = lPath
        task.arguments = args

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        task.waitUntilExit()
        
        return output
    }
    
    
    
    // builds menu items
    func constructMenu() {
        // checks current system appearence
        // var cur_appearence = NSAppearance * appearance
    
        let menu = NSMenu() // menu object
        
        // keyEquivalent specifies key command, lowercase used cmd, uppercase uses cmd + shift
        //menu.addItem(NSMenuItem(title: "✔ Light Mode", action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: "l"))
        menu.addItem(NSMenuItem(title: "✔ Toggle Dark Mode", action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: "d"))
        menu.addItem(NSMenuItem.separator())
        
        let appList = buildAppList()
        for app in appList {
  
            //let app = Bundle.main.object(forInfoDictionaryKey: app) as! String
            print(app)
            menu.addItem(NSMenuItem(title: "✔ \(app)", action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: ""))
        }
        
        
        if let path = Bundle.main.path(forResource: "/Applications/Calculator.app/Contents/Info.plist", ofType: "plist"),
            let myDict = NSDictionary(contentsOfFile: path){
            print(myDict)
            print("here")
        }
        
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
}



