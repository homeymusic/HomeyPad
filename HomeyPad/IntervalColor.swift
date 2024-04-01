// CoreGraphics is not available on Linux.
#if os(macOS) || os(iOS) || os(visionOS)
import CoreGraphics

/// Intervals represented as color.
///
public struct IntervalColor {
    
    /// Brian McAuliff Mulloy 2023, International Conference on Music Perception and Cognition (ICMPC)
    public static var homey: [CGColor] {
        [#colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1)]
    }
    
    public static var homeySubtle: [CGColor] {
        [#colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1), #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)]
    }
    
}
#endif
