import SwiftUI

struct EyeSideOverlay: View {
    let eyeSide: EyeSide

    var body: some View {
        Text(eyeSide == .left ? "Mata Kiri - OS" : "Mata Kanan - OD")
            .font(.footnote.weight(.medium))
            .foregroundStyle(AppColors.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 7)
            .eyeSideGlassCapsule()
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel(
                eyeSide == .left
                    ? "Capturing left eye"
                    : "Capturing right eye"
            )
    }
}

private extension View {
    @ViewBuilder
    func eyeSideGlassCapsule() -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(
                .regular
                    .tint(AppColors.labelPrimary.opacity(0.34))
                    .interactive(),
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
        } else {
            background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(AppColors.labelPrimary.opacity(0.36))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(AppColors.white.opacity(0.35), lineWidth: 1)
                }
        }
    }
}
