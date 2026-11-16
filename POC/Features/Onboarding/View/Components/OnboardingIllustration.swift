//
//  OnboardingIllustration.swift
//  POC
//


import SwiftUI
import Lottie

struct OnboardingIllustration: View {

    let permission: OnboardingPermission

    var body: some View {
        LottieView {
            try await DotLottieFile.named("lens_onboarding")
        }
        .playing(loopMode: .loop)
        .accessibilityLabel(permission.illustrationLabel)
        .frame(
            width: Layout.illustrationSize,
            height: Layout.illustrationSize
        )
        .frame(maxWidth: .infinity)
        .frame(height: Layout.illustrationAreaHeight)
    }
}
