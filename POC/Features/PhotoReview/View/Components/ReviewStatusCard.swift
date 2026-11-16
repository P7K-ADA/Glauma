import SwiftUI

struct ReviewStatusCard: View {

    let analysisErrorMessage: String?
    let isAnalyzing: Bool
    let qualityWarnings: [String]

    private var isError: Bool {
        analysisErrorMessage != nil
    }

    private var localizedWarnings: [String] {
        qualityWarnings.map {
            GlaumaLocalization.warning(for: $0)
        }
    }

    private var title: String {
        if isAnalyzing {
            return NSLocalizedString(
                "review.status.analyzing.title",
                comment: "Title shown while image analysis is in progress"
            )
        }

        if isError {
            return NSLocalizedString(
                "review.status.error.title",
                comment: "Title shown when image analysis fails"
            )
        }

        return NSLocalizedString(
            "review.status.success.title",
            comment: "Title shown when image quality is good"
        )
    }

    private var subtitle: String {
        if isAnalyzing {
            return NSLocalizedString(
                "review.status.analyzing.subtitle",
                comment: "Description shown while image analysis is in progress"
            )
        }

        if let analysisErrorMessage {
            return analysisErrorMessage
        }

        if !localizedWarnings.isEmpty {
            return NSLocalizedString(
                "review.status.warning.subtitle",
                comment: "Description shown when analysis has quality warnings"
            )
        }

        return NSLocalizedString(
            "review.status.success.subtitle",
            comment: "Description shown when image analysis succeeds"
        )
    }


    private var tint: Color {
        if isAnalyzing {
            return AppColors.normal
        }

        return isError ? AppColors.accentRed : AppColors.normal
    }

    private var systemName: String {
        if isAnalyzing {
            return "hourglass"
        }

        return isError
            ? "exclamationmark.circle.fill"
            : "checkmark.circle.fill"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(
                alignment: .top,
                spacing: Layout.reviewStatusContentSpacing
            ) {
                ReviewStatusIcon(
                    systemName: systemName,
                    tint: tint
                )

                VStack(
                    alignment: .leading,
                    spacing: Layout.reviewStatusTextSpacing
                ) {
                    Text(title)
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(AppColors.labelPrimary)

                    Text(subtitle)
                        .font(.footnote.weight(.regular))
                        .foregroundStyle(AppColors.labelSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            if !isAnalyzing && !isError && !localizedWarnings.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(
                        Array(localizedWarnings.enumerated()),
                        id: \.offset
                    ) { _, warning in
                        Label(
                            warning,
                            systemImage: "info.circle"
                        )
                        .font(.caption)
                        .foregroundStyle(AppColors.labelSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.leading, 4)
            }
        }
        .padding(Layout.reviewStatusCardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            AppColors.cardFills,
            in: RoundedRectangle(
                cornerRadius: Layout.reviewStatusCardCornerRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtitle)")
    }
}

private struct ReviewStatusIcon: View {

    let systemName: String
    let tint: Color

    var body: some View {
        RoundedRectangle(
            cornerRadius: Layout.reviewStatusIconCornerRadius,
            style: .continuous
        )
        .fill(tint.opacity(0.12))
        .frame(
            width: Layout.reviewStatusIconSize,
            height: Layout.reviewStatusIconSize
        )
        .overlay {
            Image(systemName: systemName)
                .font(.headline.weight(.bold))
                .foregroundStyle(tint)
        }
        .accessibilityHidden(true)
    }
}
