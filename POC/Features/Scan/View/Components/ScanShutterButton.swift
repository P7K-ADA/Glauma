
import SwiftUI

struct ScanShutterButton: View {
    let tint: Color
    let isDisabled: Bool
    let selectedEye: EyeSide
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            shutterContent
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

    @ViewBuilder
    private var shutterContent: some View {
        if #available(iOS 26.0, *) {
            ZStack {
                Circle()
                    .fill(.clear)
                    .frame(width: 85, height: 85)
                    .glassEffect(.clear, in: .circle)

                Circle()
                    .fill(tint)
                    .frame(width: 72, height: 72)
            }
            .frame(width: 90, height: 90)

        } else {
            Circle()
                .fill(tint)
                .frame(width: 72, height: 72)
                .overlay {
                    Circle()
                        .stroke(AppColors.white, lineWidth: 4)
                        .padding(-9)
                }
        }
    }
}
