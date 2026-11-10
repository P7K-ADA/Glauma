//
//  EyeDetailView.swift
//  POC
//
//  Created by Harley Ganisson on 20/10/26.
//

import SwiftUI

struct EyeDetailView: View {
    let report: ReportData
    let side: EyeSide
    @State private var isImageExpanded: Bool = false

    init(report: ReportData, initialSide: EyeSide) {
        self.report = report
        self.side = initialSide
    }

    private var eye: EyeReport {
        report.eye(side)
    }

    var body: some View {
        ScrollView {
            EyeDetailContent(
                eye: eye,
                onExpandImage: { isImageExpanded = true }
            )
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.topPadding)
            .padding(.bottom, Layout.reviewBottomPadding)
        }
        .background(AppColors.backgroundSecondary)
        .preferredColorScheme(.light)
        .navigationTitle("Detail Mata")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isImageExpanded) {
            EyeDetailExpandedImageView(
                eye: eye,
                onDismiss: { isImageExpanded = false }
            )
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        EyeDetailView(report: .sample, initialSide: .left)
    }
}
#endif
