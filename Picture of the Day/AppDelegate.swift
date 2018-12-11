//
//  AppDelegate.swift
//  Picture of the Day
//
//  Created by Vitaly Dyachkov on 8/3/18.
//  Copyright © 2018 Vitaly Dyachkov. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var manager: DesktopImageManager?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        manager = DesktopImageManager()
        manager?.update()
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        manager?.update()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

