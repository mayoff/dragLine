// Created by Rob Mayoff on 4/29/17.

import AppKit

class ConnectionDragController: NSObject, NSDraggingSource {

    var sourceEndpoint: DragEndpoint?

    func connect(to target: DragEndpoint) {
        debugPrint("Connect \(sourceEndpoint!) to \(target)")
    }

    func trackDrag(forMouseDownEvent mouseDownEvent: NSEvent, in sourceEndpoint: DragEndpoint) {
        self.sourceEndpoint = sourceEndpoint
        let item = NSDraggingItem(pasteboardWriter: NSPasteboardItem(pasteboardPropertyList: sourceEndpoint.description, ofType: NSPasteboard.PasteboardType(rawValue: kUTTypeData as String))!)
        item.setDraggingFrame(sourceEndpoint.frame, contents: nil)
        let session = sourceEndpoint.beginDraggingSession(with: [item], event: mouseDownEvent, source: self)
        session.animatesToStartingPositionsOnCancelOrFail = false
    }

    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        switch context {
        case .withinApplication: return .generic
        case .outsideApplication: return []
        @unknown default:
            fatalError()
        }
    }

    func draggingSession(_ session: NSDraggingSession, willBeginAt screenPoint: NSPoint) {
        sourceEndpoint?.state = .source
        lineOverlay = LineOverlay(startScreenPoint: screenPoint, endScreenPoint: screenPoint)
    }

    func draggingSession(_ session: NSDraggingSession, movedTo screenPoint: NSPoint) {
        lineOverlay?.endScreenPoint = screenPoint
    }

    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        lineOverlay?.removeFromScreen()
        sourceEndpoint?.state = .idle
    }

    func ignoreModifierKeys(for session: NSDraggingSession) -> Bool { return true }

    private var lineOverlay: LineOverlay?

}

