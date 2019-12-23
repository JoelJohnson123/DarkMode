// Data.swift


import Foundation


// this class will hold info about each app to be added to the menu
class appInfo {
    var name:String
    var bundleID:String
    var exempt:Bool
    
    init(name:String, bundleID:String, exempt:Bool) {
        self.name = name
        self.bundleID = bundleID
        self.exempt = exempt // true if force light mode for system dark mode
        
    }
}
