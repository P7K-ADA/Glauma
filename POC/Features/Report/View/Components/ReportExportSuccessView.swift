import SwiftUI

struct ReportExportSuccessView: View {
    let onBack: () -> Void
    let onStartNew: () -> Void

    @ScaledMetric(relativeTo: .largeTitle) private var iconSize: CGFloat = 96
    @State private var didAppear = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                content
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                    .padding(.horizontal, Layout.horizontalPadding)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .background(AppColors.appBackground)
        .safeAreaInset(edge: .bottom) { actions }
        //.preferredColorScheme(.light)
        .sensoryFeedback(.success, trigger: didAppear)
        .onAppear { didAppear = true }
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: iconSize))
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                .foregroundStyle(AppColors.normal)
                .symbolEffect(.bounce, value: didAppear)
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("Scan Saved")
                    .font(.title2.weight(.bold))
                    .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                    .foregroundStyle(AppColors.labelPrimary)
                    .accessibilityAddTraits(.isHeader)

                Text("Find your exported results in the Photos app.")
                    .font(.body)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                    .foregroundStyle(AppColors.labelSecondary)
            }
            .multilineTextAlignment(.center)
            .accessibilityElement(children: .combine)
        }
    }

    private var actions: some View {
        VStack(spacing: 24) {
            AppButton(
                title: "Start New Scan",
                tint: AppColors.primaryButtons,
                action: onStartNew
            )

            AppButton(
                title: "Back to Report",
                tint: AppColors.secondaryButtons,
                titleColor: AppColors.white,
                action: onBack
            )
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, 12)
        .padding(.bottom, Layout.reviewBottomPadding)
        .background(AppColors.appBackground)
    }
}

#Preview {
    ReportExportSuccessView(onBack: {}, onStartNew: {})
}
