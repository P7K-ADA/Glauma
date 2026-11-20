//
//  OnboardingIllustration.swift
//  POC
//

import SwiftUI
import Lottie

struct OnboardingIllustration: View {

    let permission: OnboardingPermission

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    private var animationName: String {
        switch permission {
        case .camera:
            return "cam_onboarding"
        case .photos:
            return "photos_onboarding"
        case .attachLens:
            return "lens_onboarding"
        }
    }

    private var animationHint: String {
        switch permission {
        case .camera:
            return "Camera illustration showing how Glauma captures the eye."
        case .photos:
            return "Photo library illustration showing how to select an existing eye image."
        case .attachLens:
            return "Optical lens illustration showing how to attach the lens to your iPhone."
        }
    }

    var body: some View {
        LottieView {
            try await DotLottieFile.named(animationName)
        }
        .playing(
            loopMode: reduceMotion ? .playOnce : .loop
        )
        .configure { animationView in
            animationView.contentMode = .scaleAspectFit
            animationView.clipsToBounds = false
        }
        .accessibilityHint(animationHint)
        .accessibilityHidden(true)
        .frame(
            width: Layout.illustrationSize,
            height: Layout.illustrationSize
        )
        .frame(maxWidth: .infinity)
        .frame(height: Layout.illustrationAreaHeight)
    }
}
