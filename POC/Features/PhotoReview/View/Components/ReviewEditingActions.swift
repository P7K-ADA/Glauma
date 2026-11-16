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
        ViewThatFits(in: .horizontal) {

            // Horizontal layout
            HStack(spacing: Layout.reviewButtonSpacing) {
                retakeButton
                    .frame(maxWidth: .infinity)

                continueButton
                    .frame(maxWidth: .infinity)
            }

            // Vertical layout
            VStack(spacing: Layout.reviewButtonSpacing) {
                continueButton
                    .frame(maxWidth: .infinity)

                retakeButton
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var retakeButton: some View {
        AppButton(
            title: "Retake",
            tint: AppColors.secondaryButtons,
            titleColor: AppColors.white,
            height: Layout.reviewButtonHeight,
            accessibilityLabel: "Retake photo",
            action: onRetake
        )
        .disabled(isAnalyzing)
    }

    private var continueButton: some View {
        AppButton(
            title: LocalizedStringKey(primaryTitle),
            tint: AppColors.primaryButtons,
            height: Layout.reviewButtonHeight,
            accessibilityLabel: LocalizedStringKey(primaryTitle),
            action: onContinue
        )
        .disabled(isAnalyzing)
    }
}
