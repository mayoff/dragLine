//  Created by Rob Mayoff on 4/28/17.

import Cocoa
import Carbon.HIToolbox

class DragViewController: NSViewController {

    override func mouseDown(with mouseDownEvent: NSEvent) {
        guard
            let window = view.window,
            let source = window.dragEndpoint(at: mouseDownEvent.locationInWindow)
            else { return super.mouseDown(with: mouseDownEvent) }

        let controller = ConnectionDragController()
        controller.trackDrag(forMouseDownEvent: mouseDownEvent, in: source)
    }

}

private extension NSWindow {

    func dragEndpoint(at point: CGPoint) -> DragEndpoint? {
        var view = contentView?.hitTest(point)
        while let candidate = view {
            if let endpoint = candidate as? DragEndpoint { return endpoint }
            view = candidate.superview
        }
        return nil
    }

}

