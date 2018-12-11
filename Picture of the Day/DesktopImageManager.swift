//
//  WallpaperManager.swift
//  Picture of the Day
//
//  Created by Vitaly Dyachkov on 8/6/18.
//  Copyright © 2018 Vitaly Dyachkov. All rights reserved.
//

import Cocoa

class DesktopImageManager: NSObject {

    let workspace = NSWorkspace.shared

    let provider = BingProvider()

    var desktopImageURL: URL?

    var timer: Timer?

    let reachability = Reachability()!

    override init() {
        super.init()

        workspace.notificationCenter.addObserver(forName: NSWorkspace.activeSpaceDidChangeNotification,
                                                 object: nil,
                                                 queue: OperationQueue.main) { (note) in
                                                    self.setDesktopImage(for: [NSScreen.main!])
        }

        workspace.notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification,
                                                 object: nil,
                                                 queue: OperationQueue.main) { (note) in
                                                    self.update();
        }

        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        timer = Timer(fire: tomorrow, interval: 60 * 60 * 24, repeats: true, block: { (timer) in
            self.update()
        })
        timer!.tolerance = timer!.timeInterval / 10

        RunLoop.current.add(timer!, forMode: .common)

        reachability.whenReachable = { reachability in
            self.update()
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    func update() {
        provider.update { (url) in
            self.desktopImageURL = url
            self.setDesktopImage(for: NSScreen.screens)
        }
    }

    func setDesktopImage(for screens: [NSScreen]) {
        guard let desktopImageURL = desktopImageURL else {
            return
        }
        
        for screen in screens {
            if (workspace.desktopImageURL(for: screen) != desktopImageURL) {
                try? workspace.setDesktopImageURL(desktopImageURL, for: screen)
            }
        }
    }
}
