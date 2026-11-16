//
//  SegmentationOverlay.swift
//  POC
//
//  Creates transparent disc and cup boundaries for report previews.
//

import UIKit
import CoreGraphics

enum SegmentationOverlay {

    static let discLabel: UInt8 = 1
    static let cupLabel: UInt8 = 2

    // MARK: - Overlay Appearance

    private static let fillAlpha: UInt8 = 38
    private static let boundaryAlpha: UInt8 = 255

    private static let discColor: (UInt8, UInt8, UInt8) = (
        45, 220, 135
    )

    private static let cupColor: (UInt8, UInt8, UInt8) = (
        55, 145, 255
    )

    /// Creates an overlay in the original photo's coordinate space.
    static func makeImage(
        from mask: [UInt8],
        width: Int,
        height: Int,
        canvasSize: CGSize,
        roiRectNormalized: CGRect
    ) -> UIImage? {

        guard width > 0,
              height > 0,
              mask.count == width * height,
              canvasSize.width > 0,
              canvasSize.height > 0,
              roiRectNormalized.width > 0,
              roiRectNormalized.height > 0 else {
            return nil
        }

        var pixels = [UInt8](
            repeating: 0,
            count: width * height * 4
        )

        func labelAt(_ x: Int, _ y: Int) -> UInt8 {
            mask[y * width + x]
        }

        for y in 0..<height {
            for x in 0..<width {

                let label = labelAt(x, y)

                guard label == discLabel || label == cupLabel else {
                    continue
                }

                // Detect segmentation boundary
                let left = x > 0 ? labelAt(x - 1, y) : 0
                let right = x + 1 < width ? labelAt(x + 1, y) : 0
                let up = y > 0 ? labelAt(x, y - 1) : 0
                let down = y + 1 < height ? labelAt(x, y + 1) : 0

                let isBoundary =
                    left != label ||
                    right != label ||
                    up != label ||
                    down != label

                // Select color
                let color = label == discLabel
                    ? discColor
                    : cupColor

                let alpha = Int(
                    isBoundary ? boundaryAlpha : fillAlpha
                )

                let index = (y * width + x) * 4

                // Premultiplied alpha
                pixels[index] = UInt8(
                    Int(color.0) * alpha / 255
                )

                pixels[index + 1] = UInt8(
                    Int(color.1) * alpha / 255
                )

                pixels[index + 2] = UInt8(
                    Int(color.2) * alpha / 255
                )

                pixels[index + 3] = UInt8(alpha)
            }
        }

        // MARK: - Create Mask Image

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapInfo = CGBitmapInfo(
            rawValue: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        guard let maskContext = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ),
        let maskCG = maskContext.makeImage() else {
            return nil
        }

        // MARK: - Map to Original Image

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(
            size: canvasSize,
            format: format
        )

        let rect = CGRect(
            x: roiRectNormalized.minX * canvasSize.width,
            y: roiRectNormalized.minY * canvasSize.height,
            width: roiRectNormalized.width * canvasSize.width,
            height: roiRectNormalized.height * canvasSize.height
        )

        return renderer.image { _ in
            UIImage(
                cgImage: maskCG,
                scale: 1,
                orientation: .up
            ).draw(in: rect)
        }
    }
}
