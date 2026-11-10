//
//  OnboardingHeader.swift
//  POC
//

import SwiftUI

struct OnboardingHeader: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: Layout.headerSpacing) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppColors.labelPrimary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text(message)
                .font(.footnote)
                .foregroundStyle(AppColors.labelSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: Layout.messageMaxWidth)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Layout.horizontalPadding)
        .frame(height: Layout.headerHeight)
    }
}
