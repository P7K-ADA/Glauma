
import SwiftUI

struct ScanCropMask: View {

    var body: some View {
        GeometryReader { geometry in

            // Portrait 3:4 crop ratio
            let cropHeight = geometry.size.width * 4 / 3

            // Preserve the bottom space for camera controls
            let bottomOverlayHeight = geometry.size.height * 0.195

            // Calculate the remaining top overlay
            let topOverlayHeight = max(
                0,
                geometry.size.height
                    - bottomOverlayHeight
                    - cropHeight
            )

            ZStack(alignment: .top) {

                AppColors.gray.opacity(0.75)
                    .frame(maxWidth: .infinity)
                    .frame(height: topOverlayHeight)

                AppColors.gray.opacity(0.75)
                    .frame(maxWidth: .infinity)
                    .frame(height: bottomOverlayHeight)
                    .frame(
                        maxHeight: .infinity,
                        alignment: .bottom
                    )
            }
        }
        .allowsHitTesting(false)
    }
}
