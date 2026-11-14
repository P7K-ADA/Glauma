import SwiftUI

struct SingleReportExportPage: View {
    let report: ReportData

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                eyePhotoCell(eye: report.left)
                eyePhotoCell(eye: report.right)
            }
            .background(Color.black)

            VStack(alignment: .leading, spacing: 6) {
                Text("AI DISCLAIMER")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(Color.black)

                Text("\(ReportCopy.cdrExplainer) \(ReportCopy.aiDisclaimer)")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(Color.black.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.86, green: 0.86, blue: 0.86))
        }
        .frame(width: 700)
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder
    private func eyePhotoCell(eye: EyeReport) -> some View {
        ZStack(alignment: .bottomLeading) {
            if let image = eye.image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()

                    if let mask = eye.segmentationMask,
                       let overlay = SegmentationOverlay.makeImage(
                        from: mask,
                        width: eye.maskWidth,
                        height: eye.maskHeight
                       ) {
                        Image(uiImage: overlay)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                .clipped()
            } else {
                Color.black
                    .aspectRatio(1.0, contentMode: .fit)
                    .overlay {
                        Text("No Image")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
            }

            Text("CDR : \(eye.cdrText)")
                .font(.system(size: 26, weight: .heavy))
                .foregroundStyle(.white)
                .padding(16)
                .shadow(color: .black.opacity(0.85), radius: 4, x: 2, y: 2)
        }
    }
}
