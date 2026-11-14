//
//  OnboardingPermissionPage.swift
//  POC
//

import SwiftUI

struct OnboardingPermissionPage: View {
    let permission: OnboardingPermission
    let isAllowEnabled: Bool
    let onAllow: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                title: permission.title,
                message: permission.message
            )

            OnboardingIllustration()

            Color.clear
                .frame(height: Layout.paginationAreaHeight)

            AppButton(
                title: permission == .camera ? "Next" : "Allow",
                tint: buttonTint,
                width: Layout.buttonWidth,
                height: Layout.buttonHeight,
                accessibilityLabel: permission == .camera
                    ? "Continue after attaching the optical lens."
                    : "Allow permission.",
                action: onAllow
            )
            .padding(.bottom, Layout.onboardingBottomPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.white)
    }

    private var buttonTint: Color {
        isAllowEnabled ? AppColors.accentBlue : AppColors.fillsSecondary
    }
}

#Preview("NFC belum terdeteksi") {
    OnboardingPermissionPage(
        permission: .camera,
        isAllowEnabled: false,
        onAllow: {}
    )
}

#Preview("NFC terdeteksi") {
    OnboardingPermissionPage(
        permission: .camera,
        isAllowEnabled: true,
        onAllow: {}
    )
}
