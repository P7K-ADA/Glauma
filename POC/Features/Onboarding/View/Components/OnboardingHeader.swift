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
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                .foregroundStyle(AppColors.labelPrimary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
                .padding(.top, 12)

            Text(message)
                .font(.subheadline)
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                .foregroundStyle(AppColors.labelSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: Layout.messageMaxWidth)
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Layout.horizontalPadding)
    }
}
