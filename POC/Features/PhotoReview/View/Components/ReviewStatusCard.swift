import SwiftUI

struct ReviewStatusCard: View {
    let analysisErrorMessage: String?

    private var isError: Bool {
        analysisErrorMessage != nil
    }

    private var title: String {
        guard analysisErrorMessage != nil else {
            return "Good image quality"
        }

        return "Image may be unclear"
    }

    private var subtitle: String {
        analysisErrorMessage ?? "Ready to be analyzed."
    }

    private var tint: Color {
        isError ? AppColors.accentRed : AppColors.normal
    }

    var body: some View {
        HStack(alignment: .top, spacing: Layout.reviewStatusContentSpacing) {
            ReviewStatusIcon(
                systemName: isError
                    ? "exclamationmark.circle.fill"
                    : "checkmark.circle.fill",
                isError: isError
            )

            VStack(alignment: .leading, spacing: Layout.reviewStatusTextSpacing) {
                Text(title)
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(AppColors.labelPrimary)

                Text(subtitle)
                    .font(.footnote.weight(.regular))
                    .foregroundStyle(AppColors.labelPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(Layout.reviewStatusCardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            AppColors.white,
            in: RoundedRectangle(
                cornerRadius: Layout.reviewStatusCardCornerRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("(title). (subtitle)")
    }
}


private struct ReviewStatusIcon: View {

    let systemName: String
    let isError: Bool

    var body: some View {
        Image(systemName: systemName)
            .font(.title)
            .foregroundStyle(isError ? .red : .green)
            .accessibilityHidden(true)
    }
}

