//  Nightlight.app


import Cocoa
import Foundation

// generates list of installed .apps from /applications
func buildAppList() -> Array<String> {
    // list of bundle ID's from apple apps
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
    let errorPipe = Pipe()
    task.standardOutput = pipe
    task.standardError = errorPipe
    task.launch()
   
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    _ = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    
    task.waitUntilExit()
    return output
}

// return path to app and bundle id given name of app
func bundleIDFor(appName: String) -> (String?, String) {
    if let appPath = NSWorkspace.shared.fullPath(forApplication: appName) {
        if let itsBundle = Bundle(path: appPath) { // < in my build this condition fails if we're looking for the ID of the app we're running...
            if let itsID = itsBundle.bundleIdentifier {
                return (appPath, itsID)
            }
        } else {
            //Attempt to get the current running app.
            //This is probably too simplistic a catch for every single possibility
            if let ownID =  Bundle.main.bundleIdentifier {
                return (nil, ownID)
            }
        }
    }
    return (nil, "app name never found")
}

// gets dark mode exclusion for an app, 1 means dark when dark, 0 means light when dark
func lightStatus(bundleID:String) -> Bool{
    let status = shell(lPath: "/bin/bash", args:["-c", "defaults read \(bundleID) NSRequiresAquaSystemAppearance"])

    if status == "1\n" { return true }
    else { return false } // takes system setting or has never been changed
}
