import SwiftUI

struct ReviewEditingActions: View {
    let isAnalyzing: Bool
    let hasError: Bool
    let isLastEye: Bool
    let onRetake: () -> Void
    let onContinue: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var primaryTitle: String {
        if isLastEye {
            return "View Report"
        }

        return "Continue"
    }

    var body: some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                verticalLayout
            } else {
                ViewThatFits(in: .horizontal) {
                    horizontalLayout
                    verticalLayout
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var horizontalLayout: some View {
        HStack(spacing: Layout.reviewButtonSpacing) {
            retakeButton
                .frame(maxWidth: .infinity)

            continueButton
                .frame(maxWidth: .infinity)
        }
    }

    private var verticalLayout: some View {
        VStack(spacing: Layout.reviewButtonSpacing) {
            continueButton
                .frame(maxWidth: .infinity)

            retakeButton
                .frame(maxWidth: .infinity)
        }
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
        .accessibilitySortPriority(0)
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
        .accessibilitySortPriority(1)
    }
}
