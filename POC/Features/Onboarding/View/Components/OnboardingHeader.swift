//
//  OnboardingHeader.swift
//  POC
//

import SwiftUI

struct OnboardingHeader: View {
    let title: LocalizedStringKey
    let message: LocalizedStringKey

    var body: some View {
        VStack(spacing: Layout.headerSpacing) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppColors.labelPrimary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .padding(.top, 12)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppColors.labelSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: Layout.messageMaxWidth)
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Layout.horizontalPadding)
        .frame(height: Layout.headerHeight)
    }
}
