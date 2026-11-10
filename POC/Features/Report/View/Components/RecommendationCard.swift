import SwiftUI

extension View {
    func reportCard(background: Color = AppColors.white) -> some View {
        self
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct RecommendationCard: View {
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("[AI]")
                    .foregroundStyle(AppColors.accentBlue)

                Text(title)
            }
            .font(.subheadline.weight(.semibold))
            .fixedSize(horizontal: false, vertical: true)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .reportCard()
    }
}
