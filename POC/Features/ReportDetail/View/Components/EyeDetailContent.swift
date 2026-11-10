//
//  EyeDetailContent.swift
//  POC
//

import SwiftUI

struct EyeDetailContent: View {
    let eye: EyeReport
    var onExpandImage: () -> Void = {}

    var body: some View {
        VStack(spacing: 20) {
            EyeDetailImagePreview(
                eye: eye,
                onExpand: onExpandImage
            )

            EyeDetailStatusCards(eye: eye)

            AIDisclaimerView()
                .padding(.top, 4)
        }
    }
}
