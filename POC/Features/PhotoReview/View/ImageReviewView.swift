
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

        ZStack {

            ScrollView {
                VStack(spacing: Layout.reviewSectionSpacing) {

                    ReviewHeader(onBack: onRetake)

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
        }
        .background(AppColors.appBackground)
        //.preferredColorScheme(.light)
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

#Preview("Review - Error") {
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
