//
//  AppButton.swift
//  POC
//

import SwiftUI

// Shared Liquid Glass button component.
struct AppButton: View {
    let title: String
    let tint: Color
    let titleColor: Color
    let width: CGFloat?
    let height: CGFloat
    let accessibilityLabel: String?
    let action: () -> Void

    init(
        title: String,
        tint: Color,
        titleColor: Color = AppColors.white,
        width: CGFloat? = nil,
        height: CGFloat = 50,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.tint = tint
        self.titleColor = titleColor
        self.width = width
        self.height = height
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    var body: some View {
        styledButton
    }

    private var baseButton: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(titleColor)
                .frame(
                    maxWidth: width ?? .infinity,
                    minHeight: height,
                    maxHeight: height
                )
        }
        .accessibilityLabel(accessibilityLabel ?? title)
    }

    @ViewBuilder
    private var styledButton: some View {
        if #available(iOS 26.0, *) {
            baseButton
                .buttonStyle(.glass(.regular.tint(tint)))
                .frame(
                    maxWidth: width ?? .infinity,
                    minHeight: height,
                    maxHeight: height
                )
        } else {
            baseButton
                .buttonStyle(.borderedProminent)
                .tint(tint)
                .frame(
                    maxWidth: width ?? .infinity,
                    minHeight: height,
                    maxHeight: height
                )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        AppButton(
            title: "Primary",
            tint: AppColors.accentBlue,
            width: 287,
            action: {}
        )

        AppButton(
            title: "Secondary",
            tint: AppColors.fillsSecondary,
            width: 287,
            action: {}
        )
    }
    .padding()
}
