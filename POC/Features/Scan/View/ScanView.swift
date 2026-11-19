//
//  ScanView.swift
//  POC
//

import SwiftUI

struct ScanView: View {
    @StateObject private var viewModel = ScanViewModel()

    private let pageBackground = AppColors.appBackground
    private let tint = AppColors.white

    var body: some View {
        NavigationStack {
            ZStack {
                pageBackground
                    .ignoresSafeArea()

                content

                if viewModel.isAnalyzing {
                    AppColors.gray
                        .opacity(0.85)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    ViewThatFits(in: .horizontal) {

                        // Horizontal layout
                        HStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.regular)
                                .tint(AppColors.labelSecondary)

                            Text("Analyzing photo")
                                .font(.body.weight(.semibold))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundStyle(AppColors.labelPrimary)
                                .fixedSize()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityHidden(true)

                        // Vertical layout
                        VStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.regular)
                                .tint(AppColors.labelSecondary)

                            Text("Analyzing photo")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(AppColors.labelPrimary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .frame(maxWidth: 326)
                    .analysisGlassCard()
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .continuous
                        )
                        .stroke(
                            AppColors.white.opacity(0.55),
                            lineWidth: 0.75
                        )
                    }
                    .shadow(
                        color: AppColors.labelPrimary.opacity(0.12),
                        radius: 18,
                        y: 8
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Analyzing photo")
                    .transition(
                        .opacity.combined(with: .scale(scale: 0.96))
                    )
                }

            }
            .toolbar(viewModel.isReviewing ? .visible : .hidden, for: .navigationBar)
            .navigationDestination(isPresented: $viewModel.showReport) {
                reportDestination
            }
            .onDisappear {
                viewModel.stopCamera()
            }
            .onChange(of: viewModel.selectedItem) { _, item in
                guard let item else { return }

                Task {
                    await viewModel.loadGalleryImage(item)
                }
            }
            .alert(
                "Unable to continue",
                isPresented: errorAlertBinding
            ) {
                Button("OK", role: .cancel) {
                    viewModel.dismissError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Please try again.")
            }
        }
        //.preferredColorScheme(.light)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isReviewing, let image = viewModel.selectedImage {
            ImageReviewView(
                image: image,
                onUseImage: viewModel.useEditedImage,
                onRetake: viewModel.retakeCurrentEye,
                isAnalyzing: viewModel.isAnalyzing,
                analysisErrorMessage: viewModel.analysisErrorMessage,
                debugStages: viewModel.debugStages,
                debugFailureMessage: viewModel.debugFailureMessage,
                debugVCDR: viewModel.debugVCDR,
                debugConfidence: viewModel.debugConfidence,
                qualityWarnings: viewModel.qualityWarnings,
                eyeSide: viewModel.selectedEye,
                isLastEye: viewModel.isLastEye
            )
        } else {
            ScanCameraContent(
                camera: viewModel.camera,
                selectedEye: viewModel.selectedEye,
                tint: tint,
                isAnalyzing: viewModel.isAnalyzing,
                onCapturedImage: viewModel.handleCapturedImage
            )
        }
    }

    @ViewBuilder
    private var reportDestination: some View {
        if let session = viewModel.completedSession {
            ReportOverviewView(
                report: ReportData.make(session: session),
                onDone: viewModel.resetScan
            )
        }
    }

    private var errorAlertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.dismissError()
                }
            }
        )
    }
}

private extension View {
    @ViewBuilder
    func analysisGlassCard() -> some View {
        let shape = RoundedRectangle(
            cornerRadius: 16,
            style: .continuous
        )

        if #available(iOS 26.0, *) {
            glassEffect(
                .regular
                    .tint(AppColors.white.opacity(0.2)),
                in: shape
            )
        } else {
            background(.regularMaterial, in: shape)
        }
    }
}

#Preview {
    ScanView()
}
