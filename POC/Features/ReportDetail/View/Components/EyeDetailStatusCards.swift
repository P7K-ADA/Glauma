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
        case .normal, .suspect, .highRisk:
            return AppColors.appBackground
        case .unavailable:
            return AppColors.labelSecondary.opacity(0.12)
        }
    }
    
    private let cardMinHeight: CGFloat = 108

    var body: some View {
        ViewThatFits(in: .horizontal) {

            // Horizontal layout
            HStack(spacing: 12) {
                cdrCard
                assessmentCard
            }

            // Vertical layout
            VStack(spacing: 12) {
                cdrCard
                assessmentCard
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - CDR Card

    private var cdrCard: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("Vertical CDR")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppColors.labelSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(eye.cdrText)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(statusColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: cardMinHeight, alignment: .leading)
        .background(AppColors.cardFills)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Assessment Card

    private var assessmentCard: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Assessment title
            Text("Screening Assessment")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppColors.labelSecondary)
                .fixedSize(horizontal: false, vertical: true)

            // Assessment result
            HStack(alignment: .center, spacing: 6) {
                scanStatusIcon

                scanStatusText
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: cardMinHeight, alignment: .leading)
        .background(AppColors.cardFills)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Status Icon

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

    // MARK: - Status Text

    @ViewBuilder
    private var scanStatusText: some View {
        switch eye.status {
        case .normal:
            Text("Normal")
                .font(.footnote.weight(.bold))
                .foregroundStyle(statusColor)
                .fixedSize(horizontal: false, vertical: true)

        case .suspect, .highRisk:
            Text("Glaucoma\nSuspect")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)

        case .unavailable:
            Text("Not available")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(statusColor)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
    }
}
