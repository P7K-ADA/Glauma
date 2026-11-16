//
//  EyeSummaryCard.swift
//  POC
//

import SwiftUI

struct EyeSummaryCard: View {
    let eye: EyeReport
    var showsDetailsLink = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(eye.side == .left ? "Left Eye" : "Right Eye")
                    .foregroundStyle(.primary)
                Spacer()
                Text(eye.side == .left ? "OS" : "OD")
                    .foregroundStyle(.secondary)
            }
            .font(.headline)

            SegmentationImageView(
                side: eye.side,
                image: eye.image,
                segmentationReferenceImage: eye.segmentationReferenceImage,
                segmentationMask: eye.segmentationMask,
                maskWidth: eye.maskWidth,
                maskHeight: eye.maskHeight,
                roiRectNormalized: eye.roiRectNormalized
            )
            .accessibilityHidden(true)

            HStack(alignment: .firstTextBaseline) {
                Text("vCDR")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(eye.cdrText)
                    .font(.title2.monospacedDigit().weight(.bold))
                    .foregroundStyle(eye.status.tint)
            }

            if showsDetailsLink {
                Divider()
                    .padding(.top, 2)

                HStack(spacing: 2) {
                    Text("View Details")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .reportCard()
    }
}
