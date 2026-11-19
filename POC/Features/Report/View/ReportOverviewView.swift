//
//  ReportOverviewView.swift
//  POC
//
//  Created by Harley Ganisson on 20/10/26.
//

import SwiftUI
import Photos
import UIKit

struct ReportOverviewView: View {
    @StateObject private var viewModel: ReportViewModel
    private let onDone: () -> Void
    
    @State private var showsPhotosAccessAlert = false
    @Environment(\.openURL) private var openURL

    init(
        report: ReportData,
        onDone: @escaping () -> Void = {}
    ) {
        _viewModel = StateObject(wrappedValue: ReportViewModel(report: report))
        self.onDone = onDone
    }

    private var report: ReportData { viewModel.report }
    
    @State private var shouldFinishAfterExportSuccess = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(report.capturedLine)
                    .font(.footnote)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                    .foregroundStyle(AppColors.labelSecondary)
                
                ReportEyeScansSection(report: report)
                
//                PreprocessingDetailsSection(report: report)

                RecommendationCard(
                    title: report.recommendation.title,
                    message: report.recommendation.message
                )

                AIDisclaimerView()
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.topPadding)
            .padding(.bottom, Layout.reviewBottomPadding)
        }
        .background(AppColors.appBackground)
        //.preferredColorScheme(.dark)
        .navigationTitle("Overview")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Overview")
                    .font(.headline)
                    .foregroundStyle(AppColors.labelPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(action: handleDone) {
                    Text("Done")
                        .font(.body.weight(.medium))
                        .fixedSize()
                }
                .accessibilityHint("Closes the report.")
            }
        }

        .safeAreaInset(edge: .bottom) {
            exportButton
        }
        .fullScreenCover(
            isPresented: $viewModel.showingExportSuccess,
            onDismiss: {
                if shouldFinishAfterExportSuccess {
                    shouldFinishAfterExportSuccess = false
                    finishReport()
                }
            }
        ) {
            ReportExportSuccessView(
                onBack: {
                    viewModel.showingExportSuccess = false
                },
                onStartNew: {
                    shouldFinishAfterExportSuccess = true
                    viewModel.showingExportSuccess = false
                }
            )
        }
        .alert("Export failed", isPresented: Binding(
            get: { viewModel.exportError != nil },
            set: { if !$0 { viewModel.exportError = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.exportError = nil }
        } message: {
            Text(viewModel.exportError ?? "Something went wrong. Please try again.")
        }
        .alert("Results will be deleted.", isPresented: $viewModel.showingUnsavedExportAlert) {
            Button("Export Results") {
                handleExport()
            }
            Button("Discard", role: .destructive) {
                finishReport()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You haven't exported these results yet. If you leave now, they will be lost.")
        }
    }

    private var exportButton: some View {
        let title: LocalizedStringKey = viewModel.isExporting ? "Saving..." : "Export Results"

        return AppButton(
            title: title,
            tint: AppColors.primaryButtons,
            action: handleExport
        )
        .disabled(viewModel.isExporting)
        .accessibilityHint("Saves the report images to your Photos.")
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, Layout.reviewBottomPadding)
        .background(AppColors.appBackground)
        .alert(
            "Photos Access Required",
            isPresented: $showsPhotosAccessAlert
        ) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Glauma needs permission to save your screening reports to Photos. You can enable access in Settings.")
        }
    }

    private func finishReport() {
        onDone()
    }
    
    private func handleExport() {
        Task {
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

            switch status {
            case .authorized, .limited:
                viewModel.exportReport()

            case .notDetermined:
                let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)

                if newStatus == .authorized || newStatus == .limited {
                    viewModel.exportReport()
                } else {
                    showsPhotosAccessAlert = true
                }

            case .denied, .restricted:
                showsPhotosAccessAlert = true

            @unknown default:
                showsPhotosAccessAlert = true
            }
        }
    }

    private func handleDone() {
        if viewModel.hasExported {
            finishReport()
        } else {
            viewModel.showingUnsavedExportAlert = true
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack { ReportOverviewView(report: .sample) }
}
#endif
