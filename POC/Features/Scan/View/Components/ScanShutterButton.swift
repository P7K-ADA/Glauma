import SwiftUI

struct ScanShutterButton: View {
    let tint: Color
    let isDisabled: Bool
    let selectedEye: EyeSide
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(tint)
                .frame(width: 72, height: 72)
                .overlay {
                    Circle()
                        .stroke(AppColors.white, lineWidth: 4)
                        .padding(-9)
                }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
        .accessibilityLabel(
            selectedEye == .left
                ? "Capture left eye"
                : "Capture right eye"
        )
        .accessibilityHint("Takes a photo of the current eye.")
    }
}