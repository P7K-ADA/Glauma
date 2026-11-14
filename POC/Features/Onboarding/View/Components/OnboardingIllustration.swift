//
//  OnboardingIllustration.swift
//  POC
//

import SwiftUI

struct OnboardingIllustration: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Layout.illustrationCornerRadius)
            .fill(AppColors.fillsSecondary)
            .frame(
                width: Layout.illustrationSize,
                height: Layout.illustrationSize
            )
            .overlay {
                Text("Placeholder")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.labelSecondary)
            }
            .accessibilityLabel("Optical lens illustration placeholder.")
            .frame(maxWidth: .infinity)
            .frame(height: Layout.illustrationAreaHeight)
    }
}
