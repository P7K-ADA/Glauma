import UIKit

enum ImageReviewPreviewData {
    static let image: UIImage = {
        let size = CGSize(width: 900, height: 1200)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let colors = [
                UIColor(red: 0.24, green: 0.10, blue: 0.07, alpha: 1).cgColor,
                UIColor(red: 0.82, green: 0.34, blue: 0.08, alpha: 1).cgColor,
                UIColor(red: 0.28, green: 0.08, blue: 0.05, alpha: 1).cgColor
            ]

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: [0, 0.52, 1]
            ) {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }

            let eyeRect = CGRect(
                x: 180,
                y: 310,
                width: 540,
                height: 540
            )
            UIColor(red: 0.95, green: 0.52, blue: 0.12, alpha: 0.75).setFill()
            context.cgContext.fillEllipse(in: eyeRect)

            UIColor(red: 0.55, green: 0.08, blue: 0.04, alpha: 0.72).setStroke()
            context.cgContext.setLineWidth(28)

            let paths: [UIBezierPath] = [
                {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: 450, y: 580))
                    path.addCurve(
                        to: CGPoint(x: 120, y: 430),
                        controlPoint1: CGPoint(x: 330, y: 520),
                        controlPoint2: CGPoint(x: 230, y: 450)
                    )
                    return path
                }(),
                {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: 450, y: 580))
                    path.addCurve(
                        to: CGPoint(x: 760, y: 380),
                        controlPoint1: CGPoint(x: 570, y: 520),
                        controlPoint2: CGPoint(x: 660, y: 420)
                    )
                    return path
                }(),
                {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: 450, y: 580))
                    path.addCurve(
                        to: CGPoint(x: 330, y: 930),
                        controlPoint1: CGPoint(x: 430, y: 690),
                        controlPoint2: CGPoint(x: 360, y: 820)
                    )
                    return path
                }()
            ]

            paths.forEach { $0.stroke() }
        }
    }()
}
