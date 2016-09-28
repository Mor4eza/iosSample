
import UIKit

@IBDesignable
class VerticalSlider: UIControl {

    @IBInspectable var minValue: CGFloat = 0
    @IBInspectable var maxValue: CGFloat = 100 {
        didSet {
            barLength = bounds.height - (barMargin * 2)
        }
    }
    @IBInspectable var currentValue: CGFloat = 50 {
        didSet {

            if currentValue < 0 {
                currentValue = 0
            }
            if currentValue > maxValue {
                currentValue = maxValue
            }
            setupView()
        }
    }

    let knobSize = CGSize(width: 36, height: 27)
    let barMargin:CGFloat = 15.0
    var knobRect: CGRect!
    var barLength: CGFloat!
    var isSliding = false
}

// MARK: - Lifecycle
extension VerticalSlider {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        knobRect = CGRect(x: 0, y: convertValueToY(currentValue) - (knobSize.height / 2), width: knobSize.width, height: knobSize.height)
        barLength = bounds.height - (barMargin * 2)
    }

    override func drawRect(rect: CGRect) {
        TotemStyles.drawVerticalSlider(controlFrame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), knobRect: knobRect)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}

// MARK: - Helpers
extension VerticalSlider {
    func convertYToValue(y: CGFloat) -> CGFloat {
        let offsetY = bounds.height - barMargin - y
        let value = (offsetY * maxValue) / barLength
        return value
    }
    func convertValueToY(value: CGFloat) -> CGFloat {
        let rawY = (value * barLength) / maxValue
        let offsetY = bounds.height - barMargin - rawY
        return offsetY
    }
}

// MARK: - Control Touch Handling
extension VerticalSlider {
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch  = touches.first
        if CGRectContainsPoint(knobRect, touch!.locationInView(self)) {
            isSliding = true
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
         let touch  = touches.first
        let rawY = touch!.locationInView(self).y

        if isSliding {
            let value = convertYToValue(rawY)

            if value != minValue || value != maxValue {
                currentValue = value
                print(currentValue)
                setNeedsDisplay()
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isSliding = false
    }
}
