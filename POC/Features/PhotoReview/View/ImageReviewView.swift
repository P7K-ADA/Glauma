import SwiftUI
import UIKit

struct ImageReviewView: View {
    let image: UIImage
    let onUseImage: (UIImage) -> Void
    let onRetake: () -> Void
    let isAnalyzing: Bool
    let analysisErrorMessage: String?
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
                        analysisErrorMessage: analysisErrorMessage
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
        .background(AppColors.backgroundSecondary)
        .preferredColorScheme(.light)
        .alert(
            "Foto mungkin tidak terbaca",
            isPresented: $isShowingQualityAlert
        ) {
            Button("Kembali", role: .cancel) {}

            Button("Tetap Lanjut") {
                onUseImage(image)
            }
        } message: {
            Text(
                analysisErrorMessage
                    ?? "Foto ini mungkin tidak dapat dikenali oleh model. Apakah kamu tetap ingin menggunakannya?"
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
        eyeSide: .right,
        isLastEye: true
    )
}
