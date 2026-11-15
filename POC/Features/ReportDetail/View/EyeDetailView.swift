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

    @State private var isImageExpanded = false

    init(report: ReportData, initialSide: EyeSide) {
        self.report = report
        self.side = initialSide
    }

    private var eye: EyeReport {
        report.eye(side)
    }

    var body: some View {
        EyeDetailContent(
            eye: eye,
            onExpandImage: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isImageExpanded = true
                }
            }
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.topPadding)
        .padding(.bottom, Layout.reviewBottomPadding)
        .background(
            AppColors.backgroundSecondary
                .ignoresSafeArea()
        )
        .overlay {
            if isImageExpanded {
                ZoomableSegmentationOverlay(
                    eye: eye,
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isImageExpanded = false
                        }
                    }
                )
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .navigationTitle("Detail Mata")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            AppColors.backgroundSecondary,
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar(
            isImageExpanded ? .hidden : .visible,
            for: .navigationBar
        )
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        EyeDetailView(
            report: .sample,
            initialSide: .left
        )
    }
}
#endif
