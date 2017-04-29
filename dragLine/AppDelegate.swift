//  Created by Rob Mayoff on 4/28/17.

import Cocoa

@NSApplicationMain
class AppDelegate: NSResponder, NSApplicationDelegate {

    @IBAction func newDocument(_ sender: Any?) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateInitialController() as! NSWindowController
        windowController.showWindow(nil)
    }

}

