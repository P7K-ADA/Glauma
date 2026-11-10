import SwiftUI
import UIKit

struct SegmentationImageView: View {
    let side: EyeSide
    let image: UIImage?
    let segmentationMask: [UInt8]?
    let maskWidth: Int
    let maskHeight: Int
    var aspectRatio: CGFloat = Layout.reviewImageAspectRatio

    var body: some View {
        Group {
            if let image {
                GeometryReader { geometry in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()

                        if let segmentationMask,
                           let overlay = SegmentationOverlay.makeImage(
                            from: segmentationMask,
                            width: maskWidth,
                            height: maskHeight
                           ) {
                            Image(uiImage: overlay)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        }
                    }
                }
                .aspectRatio(aspectRatio, contentMode: .fit)
                .clipped()
                .allowsHitTesting(false)
            } else {
                Color.black
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .overlay {
                        VStack(spacing: 4) {
                            Text(side.rawValue)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.white.opacity(0.7))
                            Text("No Image")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                        }
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
