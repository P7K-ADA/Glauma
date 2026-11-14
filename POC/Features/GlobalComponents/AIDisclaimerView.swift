//
//  AIDisclaimerView.swift
//  POC
//

import SwiftUI

enum ReportCopy {
    static let disclaimer = "CDR membandingkan ukuran optic cup dengan optic disc. Pemindaian ini bukan diagnosis medis dan harus diinterpretasikan lebih lanjut oleh dokter."
    static let cdrExplainer = "CDR membandingkan ukuran optic cup dengan optic disc."
    static let aiDisclaimer = "Pemindaian ini bukan diagnosis medis dan harus diinterpretasikan lebih lanjut oleh dokter."
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
