import SwiftUI

struct ScanCropMask: View {
    var body: some View {
        GeometryReader { geometry in
            let topOverlayHeight = geometry.size.height * 0.108
            let bottomOverlayHeight = geometry.size.height * 0.195

            ZStack(alignment: .top) {
                AppColors.labelPrimary.opacity(0.50)
                    .frame(maxWidth: .infinity)
                    .frame(height: topOverlayHeight)

                AppColors.labelPrimary.opacity(0.50)
                    .frame(maxWidth: .infinity)
                    .frame(height: bottomOverlayHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .allowsHitTesting(false)
    }
}