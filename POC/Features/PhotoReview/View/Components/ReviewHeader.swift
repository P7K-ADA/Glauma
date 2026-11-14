import SwiftUI

struct ReviewHeader: View {
    let onBack: () -> Void

    var body: some View {
        ZStack {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.medium))
                        .foregroundStyle(AppColors.labelPrimary)
                        .frame(
                            width: Layout.reviewHeaderControlSize,
                            height: Layout.reviewHeaderControlSize
                        )
                }
                .buttonStyle(.plain)
                .reviewGlassCircleButton()
                .accessibilityLabel("Back")
                .accessibilityHint("Returns to the camera to retake the image.")

                Spacer()
            }

            Text("Review")
                .font(.headline.weight(.bold))
                .foregroundStyle(AppColors.labelPrimary)
                .accessibilityAddTraits(.isHeader)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension View {
    @ViewBuilder
    func reviewGlassCircleButton() -> some View {
        let shape = Circle()

        if #available(iOS 26.0, *) {
            glassEffect(
                .regular.tint(AppColors.white.opacity(0.18)),
                in: shape
            )
        } else {
            background(.regularMaterial, in: shape)
        }
    }
}
