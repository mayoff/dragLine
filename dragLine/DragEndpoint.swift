//  Created by Rob Mayoff on 4/28/17.

import Cocoa

@IBDesignable
class DragEndpoint: NSView {

    enum State {
        case idle
        case source
        case target
    }

    var state: State = State.idle { didSet { needsLayout = true } }

    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard case .idle = state else { return [] }
        guard (sender.draggingSource as? ConnectionDragController)?.sourceEndpoint != nil else { return [] }
        state = .target
        return sender.draggingSourceOperationMask
    }

    public override func draggingExited(_ sender: NSDraggingInfo?) {
        guard case .target = state else { return }
        state = .idle
    }

    public override func draggingEnded(_ sender: NSDraggingInfo?) {
        guard case .target = state else { return }
        state = .idle
    }

    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let controller = sender.draggingSource as? ConnectionDragController else { return false }
        controller.connect(to: self)
        return true
    }

    override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }

    private func commonInit() {
        wantsLayer = true
        registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: kUTTypeData as String)])
    }

    override func makeBackingLayer() -> CALayer {
        return shapeLayer
    }

    override var intrinsicContentSize: CGSize { return CGSize(width: 80, height: 80) }

    override func layout() {
        super.layout()

        setAppearanceForState()
        shapeLayer.path = CGPath(roundedRect: bounds.insetBy(dx: shapeLayer.lineWidth / 2, dy: shapeLayer.lineWidth / 2), cornerWidth: 8, cornerHeight: 8, transform: nil)
    }
    
    private let shapeLayer = CAShapeLayer()

    private func setAppearanceForState() {
        shapeLayer.lineWidth = 3
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        switch state {
        case .idle:
            shapeLayer.strokeColor = NSColor.darkGray.cgColor
            shapeLayer.fillColor = NSColor.lightGray.cgColor
        case .source:
            shapeLayer.strokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
            shapeLayer.fillColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor
        case .target:
            shapeLayer.strokeColor = NSColor.selectedKnobColor.cgColor
            shapeLayer.fillColor = NSColor.selectedControlColor.cgColor
        }
    }

}
