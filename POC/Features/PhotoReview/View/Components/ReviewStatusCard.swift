import SwiftUI

struct ReviewStatusCard: View {
    let analysisErrorMessage: String?
    let isAnalyzing: Bool
    let qualityWarnings: [String]

    private var isError: Bool {
        analysisErrorMessage != nil
    }

    private var title: String {
        guard analysisErrorMessage != nil else {
            return "Good image quality"
        if isAnalyzing {
            return "Menganalisis Foto"
        }

        return "Image may be unclear"
        if isError {
            return "Foto mungkin tidak terbaca"
        }

        return "Kualitas Gambar Baik"
    }

    private var subtitle: String {
        analysisErrorMessage ?? "Ready to be analyzed."
        if isAnalyzing {
            return "Memeriksa kualitas gambar dan melakukan segmentasi optic disc dan optic cup."
        }

        if let analysisErrorMessage {
            return analysisErrorMessage
        }

        if !qualityWarnings.isEmpty {
            return "Analisis selesai dengan beberapa catatan kualitas."
        }

        return "Foto berhasil diproses dan siap digunakan."
    }

//    private var tint: Color {
//        isError ? AppColors.accentRed : AppColors.normal
//    }
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

        return isError ? "exclamationmark" : "checkmark"
    }

    var body: some View {
        HStack(alignment: .top, spacing: Layout.reviewStatusContentSpacing) {
            ReviewStatusIcon(
                systemName: isError
                    ? "exclamationmark.circle.fill"
                    : "checkmark.circle.fill",
                isError: isError
            )
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
                    Text(subtitle)
                        .font(.footnote.weight(.regular))
                        .foregroundStyle(AppColors.labelPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }

            if !isAnalyzing && !isError && !qualityWarnings.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(qualityWarnings, id: \.self) { warning in
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
    let isError: Bool

    var body: some View {
        Image(systemName: systemName)
            .font(.title)
            .foregroundStyle(isError ? .red : .green)
            .accessibilityHidden(true)
    }
}

