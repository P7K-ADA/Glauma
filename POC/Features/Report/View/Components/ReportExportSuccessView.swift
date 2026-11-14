import SwiftUI

struct ReportExportSuccessView: View {
    let onBack: () -> Void
    let onStartNew: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(systemName: "checkmark")
                .font(.system(size: 92, weight: .bold))
                .foregroundStyle(AppColors.normal)
                .frame(width: 220, height: 220)
                .overlay {
                    Circle()
                        .stroke(AppColors.normal, lineWidth: 12)
                }
                .accessibilityHidden(true)

            VStack(spacing: 4) {
                Text("Foto Berhasil Disimpan")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppColors.labelPrimary)
                Text("Periksa hasil ekspor di Galeri Foto.")
                    .font(.body)
                    .foregroundStyle(AppColors.labelPrimary)
            }
            .padding(.top, 36)

            Spacer()

            HStack(spacing: Layout.reviewButtonSpacing) {
                AppButton(
                    title: "Kembali",
                    tint: AppColors.fillsSecondary,
                    titleColor: AppColors.labelSecondary,
                    action: onBack
                )

                AppButton(
                    title: "Mulai Baru",
                    tint: AppColors.accentBlue,
                    action: onStartNew
                )
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.topPadding)
        .padding(.bottom, Layout.reviewBottomPadding)
        .background(AppColors.backgroundSecondary)
    }
}

#Preview {
    ReportExportSuccessView(onBack: {}, onStartNew: {})
}
