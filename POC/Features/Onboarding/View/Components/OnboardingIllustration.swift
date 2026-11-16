//
//  OnboardingIllustration.swift
//  POC
//

import SwiftUI

struct OnboardingIllustration: View {
    let permission: OnboardingPermission
    
    var body: some View {
        RoundedRectangle(cornerRadius: Layout.illustrationCornerRadius)
            .fill(AppColors.labelPrimary)
            .frame(
                width: Layout.illustrationSize,
                height: Layout.illustrationSize
            )
            .overlay {
                Text("Placeholder")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.labelSecondary)
            }
            .accessibilityLabel(permission.illustrationLabel)
            .frame(maxWidth: .infinity)
            .frame(height: Layout.illustrationAreaHeight)
    }
}
