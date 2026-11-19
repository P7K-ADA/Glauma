import SwiftUI
import UIKit

struct ImageReviewView: View {

    let image: UIImage
    let onUseImage: (UIImage) -> Void
    let onRetake: () -> Void

    let isAnalyzing: Bool
    let analysisErrorMessage: String?

    let debugStages: [String: UIImage]
    let debugFailureMessage: String?
    let debugVCDR: Double?
    let debugConfidence: Double?

    let qualityWarnings: [String]

    let eyeSide: EyeSide
    let isLastEye: Bool

    @State private var isShowingQualityAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: Layout.reviewSectionSpacing) {

                ReviewImageCanvas(
                    image: image,
                    eyeSide: eyeSide
                )

                ReviewStatusCard(
                    analysisErrorMessage: analysisErrorMessage,
                    isAnalyzing: isAnalyzing,
                    qualityWarnings: qualityWarnings
                )

                ReviewEditingActions(
                    isAnalyzing: isAnalyzing,
                    hasError: analysisErrorMessage != nil,
                    isLastEye: isLastEye,
                    onRetake: onRetake,
                    onContinue: {
                        if analysisErrorMessage != nil {
                            isShowingQualityAlert = true
                        } else {
                            onUseImage(image)
                        }
                    }
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.topPadding)
            .padding(.bottom, Layout.reviewBottomPadding)
        }
        .scrollIndicators(.hidden)
        .background(AppColors.appBackground)
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {

            ToolbarItem(placement: .principal) {
                Text("Review")
                    .font(.headline)
                    .foregroundStyle(AppColors.labelPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            ToolbarItem(placement: .topBarLeading) {
                Button(action: onRetake) {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.medium))
                        .foregroundStyle(AppColors.labelPrimary)
                }
                .accessibilityLabel("Back")
                .accessibilityHint(
                    "Returns to the camera to retake the image."
                )
            }
        }
        .alert(
            "Image may be unclear",
            isPresented: $isShowingQualityAlert
        ) {
            Button("Retake", role: .cancel) {}

            Button("Continue") {
                onUseImage(image)
            }
        } message: {
            Text(
                analysisErrorMessage
                    ?? "The model may not be able to identify the vCDR from the image. Are you sure you want to continue?"
            )
        }
    }
}

#Preview("Review - Ready") {
    NavigationStack {
        ImageReviewView(
            image: ImageReviewPreviewData.image,
            onUseImage: { _ in },
            onRetake: {},
            isAnalyzing: false,
            analysisErrorMessage: nil,
            debugStages: [:],
            debugFailureMessage: nil,
            debugVCDR: nil,
            debugConfidence: nil,
            qualityWarnings: [],
            eyeSide: .left,
            isLastEye: false
        )
    }
}

#Preview("Review - Error") {
    NavigationStack {
        ImageReviewView(
            image: ImageReviewPreviewData.image,
            onUseImage: { _ in },
            onRetake: {},
            isAnalyzing: false,
            analysisErrorMessage: "The image is blurry. Please hold the camera steady and retake the photo.",
            debugStages: [:],
            debugFailureMessage: nil,
            debugVCDR: nil,
            debugConfidence: nil,
            qualityWarnings: [],
            eyeSide: .right,
            isLastEye: true
        )
    }
}
