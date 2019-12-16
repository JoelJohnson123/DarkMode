//
//  LightDark.swift
//  Switch Appearence
//
//  Created by Joel Johnson on 12/15/19.
//  Copyright © 2019 Joel Johnson. All rights reserved.
//

import Cocoa
import Foundation

// generates list of installed .apps from /applications
func buildAppList() -> Array<String> {
    // list of bundle ID's from apple apps
    let macosApps = ["com.apple.AppStore", "com.apple.iBooksX", "com.apple.calculator", "com.apple.iCal",
                    "com.apple.AddressBook", "com.apple.Dictionary",
                    "com.apple.FaceTime", "com.apple.FontBook", "com.apple.iWork.Keynote", "com.apple.mail",
                    "com.apple.Image_Capture", "com.apple.Maps", "com.apple.iChat", "com.apple.Notes", "com.apple.news",
                    "com.apple.iWork.Numbers", "com.apple.iWork.Pages", "com.apple.PhotoBooth", "com.apple.Photos",
                    "com.apple.Preview", "com.apple.QuickTimePlayerX", "com.apple.reminders", "com.apple.Safari",
                    "com.apple.stocks", "com.apple.systempreferences", "com.apple.TextEdit", "com.apple.VoiceMemos",
                    "com.apple.iMovieApp", "com.apple.iTunes"]
    
    let appIds = ["Activity Monitor.app", "App Store.app", "Books.app", "Calculator.app", "Calendar.app", "Contacts.app",
                  "Dictionary.app", "FaceTime.app", "Finder.app", "Font Book.app", "GarageBand.app", "Google Chrome.app",
                  "iMovie.app", "iTunes.app", "Keynote.app", "Mail.app", "Maps.app", "Messages.app", "News.app",
                  "Notes.app", "Numbers.app", "Pages.app", "Photos.app", "Preview.app", "QuickTime Player.app",
                  "Reminders.app", "Safari.app", "Stickies.app", "Stocks.app", "System Preferences.app",
                  "TextEdit.app", "Xcode.app"]
    
    return appIds
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


func bundleIDFor(appNamed appName: String) -> String {
    if let appPath = NSWorkspace.shared.fullPath(forApplication: appName) {
        if let itsBundle = Bundle(path: appPath) { // < in my build this condition fails if we're looking for the ID of the app we're running...
            if let itsID = itsBundle.bundleIdentifier {
                print(itsID)
                return itsID
            }
        } else {
            //Attempt to get the current running app.
            //This is probably too simplistic a catch for every single possibility
            if let ownID =  Bundle.main.bundleIdentifier {
                return ownID
            }
        }
    }
    return "nil"
}

// gets dark mode exclusion for an app, 1 means dark when dark, 0 means light when dark
func lightStatus(app:String) -> Bool{
    let status = shell(lPath: "/bin/bash", args:["-c", "defaults read \(app) NSRequiresAquaSystemAppearance"])
    print("status: \(status)")

    if status == "1\n" { return true }
    else { return false } // takes system setting or has never been changed
}
