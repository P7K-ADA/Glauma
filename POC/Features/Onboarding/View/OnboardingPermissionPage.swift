//
//  OnboardingPermissionPage.swift
//  POC
//

import SwiftUI

struct OnboardingPermissionPage: View {

    let permission: OnboardingPermission
    let pageIndex: Int
    let pageCount: Int
    let isAllowEnabled: Bool
    let onAllow: () -> Void
    let onSkip: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                OnboardingHeader(
                    title: permission.title,
                    message: permission.message
                )
                .padding(.top, 12)
                .padding(.bottom, 12)

                OnboardingIllustration(permission: permission)

                OnboardingPageIndicator(
                    count: pageCount,
                    currentIndex: pageIndex
                )
                .padding(.top, 12)
                .padding(.bottom, 12)

                AppButton(
                    title: "Continue",
                    tint: buttonTint,
                    width: Layout.buttonWidth,
                    height: Layout.buttonHeight,
                    accessibilityLabel: permission == .attachLens
                        ? "Continue after attaching the optical lens."
                        : "Continue to the permission request.",
                    action: onAllow
                )
                .padding(.top, 24)
                .padding(.bottom, 12)

                if permission.isSkippable {
                    Button("Not now", action: onSkip)
                        .font(.body)
                        .foregroundStyle(AppColors.labelSecondary)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                        .accessibilityHint("Skip this step for now.")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.bottom, Layout.onboardingBottomPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.appBackground)
    }

    private var buttonTint: Color {
        isAllowEnabled ? AppColors.primaryButtons : AppColors.secondaryButtons
    }
}

private struct OnboardingPageIndicator: View {

    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(
                        index == currentIndex
                            ? AppColors.primaryButtons
                            : AppColors.secondaryButtons
                    )
                    .frame(width: 8, height: 8)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(currentIndex + 1) of \(count)")
    }
}


#Preview("Camera") {
    OnboardingPermissionPage(
        permission: .camera,
        pageIndex: 0,
        pageCount: 3,
        isAllowEnabled: true,
        onAllow: {},
        onSkip: {}
    )
}

#Preview("Photos (skippable)") {
    OnboardingPermissionPage(
        permission: .photos,
        pageIndex: 1,
        pageCount: 3,
        isAllowEnabled: true,
        onAllow: {},
        onSkip: {}
    )
}

#Preview("Attach lens - NFC not detected") {
    OnboardingPermissionPage(
        permission: .attachLens,
        pageIndex: 2,
        pageCount: 3,
        isAllowEnabled: false,
        onAllow: {},
        onSkip: {}
    )
}

#Preview("Attach lens - NFC detected") {
    OnboardingPermissionPage(
        permission: .attachLens,
        pageIndex: 2,
        pageCount: 3,
        isAllowEnabled: true,
        onAllow: {},
        onSkip: {}
    )
}
