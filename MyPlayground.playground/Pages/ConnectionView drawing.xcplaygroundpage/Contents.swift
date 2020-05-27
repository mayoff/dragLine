    import Cocoa

    extension CGPath {
        class func barbell(from start: CGPoint, to end: CGPoint, barThickness proposedBarThickness: CGFloat, bellRadius proposedBellRadius: CGFloat) -> CGPath {
            let barThickness = max(0, proposedBarThickness)
            let bellRadius = max(barThickness / 2, proposedBellRadius)

            let vector = CGPoint(x: end.x - start.x, y: end.y - start.y)
            let length = hypot(vector.x, vector.y)

            if length == 0 {
                return CGPath(ellipseIn: CGRect(origin: start, size: .zero).insetBy(dx: -bellRadius, dy: -bellRadius), transform: nil)
            }

            var yOffset = barThickness / 2
            var xOffset = sqrt(bellRadius * bellRadius - yOffset * yOffset)
            let halfLength = length / 2
            if xOffset > halfLength {
                xOffset = halfLength
                yOffset = sqrt(bellRadius * bellRadius - xOffset * xOffset)
            }

            let jointRadians = asin(yOffset / bellRadius)
            let path = CGMutablePath()
            path.addArc(center: .zero, radius: bellRadius, startAngle: jointRadians, endAngle: -jointRadians, clockwise: false)
            path.addArc(center: CGPoint(x: length, y: 0), radius: bellRadius, startAngle: .pi + jointRadians, endAngle: .pi - jointRadians, clockwise: false)
            path.closeSubpath()

            let unitVector = CGPoint(x: vector.x / length, y: vector.y / length)
            var transform = CGAffineTransform(a: unitVector.x, b: unitVector.y, c: -unitVector.y, d: unitVector.x, tx: start.x, ty: start.y)
            return path.copy(using: &transform)!
        }
    }

    class ConnectionView: NSView {
        struct Parameters {
            var startPoint = CGPoint.zero
            var endPoint = CGPoint.zero
            var barThickness = CGFloat(2)
            var ballRadius = CGFloat(3)
        }

        var parameters = Parameters() { didSet { needsLayout = true } }

        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder decoder: NSCoder) {
            super.init(coder: decoder)
            commonInit()
        }

        let shapeLayer = CAShapeLayer()
        override func makeBackingLayer() -> CALayer { return shapeLayer }

        override func layout() {
            super.layout()

            shapeLayer.path = CGPath.barbell(from: parameters.startPoint, to: parameters.endPoint, barThickness: parameters.barThickness, bellRadius: parameters.ballRadius)
            shapeLayer.shadowPath = CGPath.barbell(from: parameters.startPoint, to: parameters.endPoint, barThickness: parameters.barThickness + shapeLayer.lineWidth / 2, bellRadius: parameters.ballRadius + shapeLayer.lineWidth / 2)
        }

        private func commonInit() {
            wantsLayer = true

            shapeLayer.lineJoin = CAShapeLayerLineJoin.miter
            shapeLayer.lineWidth = 0.75
            shapeLayer.strokeColor = NSColor.white.cgColor
            shapeLayer.fillColor = NSColor(calibratedHue: 209/360, saturation: 0.83, brightness: 1, alpha: 1).cgColor
            shapeLayer.shadowColor = NSColor.selectedControlColor.blended(withFraction: 0.2, of: .black)?.withAlphaComponent(0.85).cgColor
            shapeLayer.shadowRadius = 3
            shapeLayer.shadowOpacity = 1
            shapeLayer.shadowOffset = .zero
        }
    }

    import PlaygroundSupport

    let view = NSView()
    view.setFrameSize(CGSize(width: 400, height: 200))
    view.wantsLayer = true
    view.layer!.backgroundColor = NSColor.white.cgColor

    PlaygroundPage.current.liveView = view

    for i: CGFloat in stride(from: 0, through: 9, by: CGFloat(0.4)) {
        let connectionView = ConnectionView(frame: view.bounds)
        connectionView.parameters.startPoint = CGPoint(x: CGFloat(i) * 40 + 15, y: 50)
        connectionView.parameters.endPoint = CGPoint(x: CGFloat(i) * 40 + 15, y: 50 + CGFloat(i))
        view.addSubview(connectionView)
    }

    let connectionView = ConnectionView(frame: view.bounds)
    connectionView.parameters.startPoint = CGPoint(x: 50, y: 100)
    connectionView.parameters.endPoint = CGPoint(x: 350, y: 150)
    view.addSubview(connectionView)

