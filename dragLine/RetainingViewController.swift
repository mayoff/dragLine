//  Created by Rob Mayoff on 4/29/17.

import Cocoa

class RetainingViewController: NSViewController {

    override func viewDidAppear() {
        super.viewDidAppear()

        // Even when an `NSWindow` is visible, AppKit doesn't necessarily retain it. And if nothing retains it, it'll be deallocated and disappear. The only reliable, documented way to be notified when a window appears is to implement `viewDidAppear` in the window's `contentViewController`. That's me. So here, I create a retain cycle to keep the window alive until it's closed.
        window = view.window
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        window = nil
    }

    private var window: NSWindow?

}
