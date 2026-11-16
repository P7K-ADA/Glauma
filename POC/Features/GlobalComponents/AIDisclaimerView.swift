//
//  AIDisclaimerView.swift
//  POC
//

import SwiftUI

enum ReportCopy {
    static var disclaimer: String {
        String(localized: "report.disclaimer")
    }
}

struct AIDisclaimerView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle")
                .font(.footnote)
                .foregroundStyle(AppColors.labelSecondary)
                .padding(.top, 1)

            Text(ReportCopy.disclaimer)
                .font(.caption)
                .foregroundStyle(AppColors.labelSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
#Preview {
    AIDisclaimerView()
        .padding()
}
#endif
