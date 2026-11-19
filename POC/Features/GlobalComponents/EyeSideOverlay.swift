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
                .fill(.black.opacity(0.55))
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
