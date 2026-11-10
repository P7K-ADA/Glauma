//
//  EyeDetailStatusCards.swift
//  POC
//

import SwiftUI

struct EyeDetailStatusCards: View {
    let eye: EyeReport

    private var statusColor: Color {
        switch eye.status {
        case .normal:
            return AppColors.normal
        case .suspect, .highRisk:
            return AppColors.suspect
        case .unavailable:
            return AppColors.labelSecondary
        }
    }

    private var statusBackgroundColor: Color {
        switch eye.status {
        case .normal:
            return AppColors.normalBackground
        case .suspect, .highRisk:
            return AppColors.suspectBackground
        case .unavailable:
            return AppColors.labelSecondary.opacity(0.12)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Card 1: Hasil Pemindaian
            VStack(alignment: .leading, spacing: 6) {
                Text("Hasil Pemindaian")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppColors.labelSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 0)

                HStack(alignment: .center, spacing: 6) {
                    scanStatusIcon

                    scanStatusText
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 102)
            .background(statusBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Card 2: Rasio CDR Vertikal
            VStack(alignment: .leading, spacing: 6) {
                Text("Rasio CDR Vertikal")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppColors.labelSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 0)

                Text(eye.cdrText)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(statusColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 102)
            .background(statusBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    @ViewBuilder
    private var scanStatusIcon: some View {
        switch eye.status {
        case .normal:
            Image(systemName: "checkmark")
                .font(.title3.weight(.bold))
                .foregroundStyle(statusColor)
        case .suspect, .highRisk:
            Image(systemName: "arrow.up")
                .font(.title3.weight(.bold))
                .foregroundStyle(statusColor)
        case .unavailable:
            Image(systemName: "questionmark")
                .font(.title3.weight(.bold))
                .foregroundStyle(statusColor)
        }
    }

    @ViewBuilder
    private var scanStatusText: some View {
        switch eye.status {
        case .normal:
            Text("Batas\nNormal")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.8)
        case .suspect, .highRisk:
            Text("Suspek\nGlaukoma")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.8)
        case .unavailable:
            Text("Tidak\nTersedia")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.8)
        }
    }
}
