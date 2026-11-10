import SwiftUI

struct ReviewEditingActions: View {
    let isAnalyzing: Bool
    let hasError: Bool
    let isLastEye: Bool
    let onRetake: () -> Void
    let onContinue: () -> Void

    private var primaryTitle: String {
        if hasError {
            return "Tetap Lanjut"
        }

        return isLastEye ? "Lihat Laporan" : "Lanjut ke OD"
    }

    var body: some View {
        HStack(spacing: Layout.reviewButtonSpacing) {
            AppButton(
                title: "Foto Ulang",
                tint: AppColors.fillsSecondary,
                titleColor: AppColors.labelSecondary,
                height: Layout.reviewButtonHeight,
                accessibilityLabel: "Retake photo",
                action: onRetake
            )
            .frame(maxWidth: .infinity)
            .disabled(isAnalyzing)

            AppButton(
                title: primaryTitle,
                tint: AppColors.accentBlue,
                height: Layout.reviewButtonHeight,
                accessibilityLabel: primaryTitle,
                action: onContinue
            )
            .frame(maxWidth: .infinity)
            .disabled(isAnalyzing)
        }
        .frame(maxWidth: .infinity)
        .frame(height: Layout.reviewButtonHeight)
    }
}
