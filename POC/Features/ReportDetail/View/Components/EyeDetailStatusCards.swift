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
            return AppColors.appBackground
        case .suspect, .highRisk:
            return AppColors.appBackground
        case .unavailable:
            return AppColors.labelSecondary.opacity(0.12)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Card 1: Vertical CDR
            VStack(alignment: .leading, spacing: 6) {
                Text("Vertical CDR")
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
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            //.frame(height: 80)
            .background(AppColors.cardFills)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Card 2: Scan Result
            VStack(alignment: .leading, spacing: 6) {
                Text("Screening Assessment")
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
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            //.frame(height: 80)
            .background(AppColors.cardFills)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    @ViewBuilder
    private var scanStatusIcon: some View {
        switch eye.status {
        case .normal:
            Image(systemName: "checkmark.circle.fill")
                .font(.title3.weight(.bold))
                .foregroundStyle(statusColor)
        case .suspect, .highRisk:
            Image(systemName: "exclamationmark.triangle.fill")
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
            Text("Normal")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.8)
        case .suspect, .highRisk:
            Text("Glaucoma\nSuspect")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.8)
        case .unavailable:
            Text("Not\nAvailable")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.8)
        }
    }
}
