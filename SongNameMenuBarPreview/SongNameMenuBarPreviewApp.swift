//
//  SongNameMenuBarPreviewApp.swift
//  SongNameMenuBarPreview
//
//  Created by Ani Mehta on 24/8/21.
//

import SwiftUI

@main
struct MenuBarPopoverApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
      AppDelegate.shared = self.appDelegate
    }
    var body: some Scene {
        Settings{
            EmptyView()
        }
    }
}
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    var statusBarItem: NSStatusItem?
    static var shared : AppDelegate!
    var title = nowPlaying()

    func applicationWillFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
        
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
        popover.contentViewController?.view.window?.makeKey()
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.title = title
        statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.global().async {
            while true {
                self.getNowPlayingAndUpdateUI()
            }
        }
    }

    func getNowPlayingAndUpdateUI() {
        Thread.sleep(forTimeInterval: 1)
        title = nowPlaying()
        DispatchQueue.main.async {
            self.statusBarItem?.button?.title = self.title
        }
    }

    func applicationWillResignActive(_ notification: Notification) {
        popover.performClose(notification.self)
    }
    @objc func showPopover(_ sender: AnyObject?) {
        if let button = statusBarItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    @objc func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}
