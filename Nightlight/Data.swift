// Data.swift
import Foundation
import Cocoa

// this class will hold info about each app added to the menu
class appInfo {
    let name:String
    let bundleID:String
    var exempt:Bool
    let path:String
    let icon:NSImage
    
    init(name:String, bundleID:String, exempt:Bool, path:String, icon:NSImage) {
        self.name = name
        self.bundleID = bundleID
        self.exempt = exempt // true if force light mode for system dark mode
        self.path = path
        self.icon = icon
    }
}
