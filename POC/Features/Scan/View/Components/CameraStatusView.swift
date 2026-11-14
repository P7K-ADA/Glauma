import SwiftUI

struct CameraStatusView: View {
    let status: String
    let errorMessage: String?

    var body: some View {
        VStack(spacing: 4) {
            if let errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(AppColors.accentRed)
                    .multilineTextAlignment(.center)
            } else if !status.isEmpty {
                Text(status)
                    .font(.caption)
                    .foregroundStyle(AppColors.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.labelPrimary.opacity(0.72), in: Capsule())
    }
}