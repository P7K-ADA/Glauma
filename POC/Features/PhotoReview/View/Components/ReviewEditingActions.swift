import SwiftUI

struct ReviewEditingActions: View {
    let isAnalyzing: Bool
    let hasError: Bool
    let isLastEye: Bool
    let onRetake: () -> Void
    let onContinue: () -> Void

    private var primaryTitle: String {
        if hasError {
            return "Continue"
        }

        return isLastEye ? "View Report" : "Continue"
    }

    var body: some View {
        HStack(spacing: Layout.reviewButtonSpacing) {
            AppButton(
                title: "Retake",
                tint: AppColors.fillsSecondary,
                titleColor: AppColors.labelSecondary,
                height: Layout.reviewButtonHeight,
                accessibilityLabel: "Retake photo",
                action: onRetake
            )
            .frame(maxWidth: .infinity)
            .disabled(isAnalyzing)

            AppButton(
                title: LocalizedStringKey(primaryTitle),
                tint: AppColors.primaryButtons,
                height: Layout.reviewButtonHeight,
                accessibilityLabel: LocalizedStringKey(primaryTitle),
                action: onContinue
            )
            .frame(maxWidth: .infinity)
            .disabled(isAnalyzing)
        }
        .frame(maxWidth: .infinity)
        .frame(height: Layout.reviewButtonHeight)
    }
}
