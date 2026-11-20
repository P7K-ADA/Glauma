
import SwiftUI

struct EyeSideOverlay: View {

    let eyeSide: EyeSide

    var body: some View {
        Text(eyeSide == .left ? "Left Eye - OS" : "Right Eye - OD")
            .font(.caption.weight(.medium))
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            .foregroundStyle(.white)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background {
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                )
                .eyeSideGlass()
            }
            .fixedSize(horizontal: true, vertical: false)
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
    func eyeSideGlass() -> some View {
        let shape = RoundedRectangle(
            cornerRadius: 8,
            style: .continuous
        )

        if #available(iOS 26.0, *) {
            glassEffect(
                .regular.tint(AppColors.gray.opacity(0.5)),
                in: shape
            )
        } else {
            background(.regularMaterial, in: shape)
        }
    }
}


#Preview("Eye Side Overlay") {
    ZStack {
        Color.gray
            .ignoresSafeArea()

        VStack(spacing: 20) {
            EyeSideOverlay(eyeSide: .left)
            EyeSideOverlay(eyeSide: .right)
        }
    }
    .preferredColorScheme(.dark)
}
