import SwiftUI
import UIKit

struct ReviewImageCanvas: View {
    let image: UIImage
    let eyeSide: EyeSide

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .aspectRatio(Layout.reviewImageAspectRatio, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Layout.reviewImageCornerRadius,
                    style: .continuous
                )
            )
            .overlay(alignment: .top) {
                EyeSideOverlay(eyeSide: eyeSide)
                    .padding(.top, Layout.reviewEyeOverlayTopPadding)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Captured eye image")
    }
}
