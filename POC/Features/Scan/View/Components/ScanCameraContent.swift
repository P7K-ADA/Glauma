import SwiftUI
import UIKit

struct ScanCameraContent: View {
    @ObservedObject var camera: CameraService
    let selectedEye: EyeSide
    let tint: Color
    let isAnalyzing: Bool
    let onCapturedImage: (UIImage) -> Void

    @State private var focusPoint: CGPoint?
    @State private var focusID = UUID()
    @State private var baseZoom: CGFloat = 1

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColors.labelPrimary
                    .ignoresSafeArea()

                CameraPreview(session: camera.session)
                    .ignoresSafeArea()

                ScanCropMask()
                    .ignoresSafeArea()

                if let focusPoint {
                    FocusSquareView(color: tint)
                        .position(focusPoint)
                        .id(focusID)
                }

                VStack(spacing: 0) {
                    if camera.errorMessage != nil {
                        CameraStatusView(
                            status: camera.status,
                            errorMessage: camera.errorMessage
                        )
                        .padding(.top, geometry.safeAreaInsets.top + 64)
                    }

                    Spacer()

                    ScanZoomControl(camera: camera)
                    .padding(.bottom, 84)

                    ScanShutterButton(
                        tint: tint,
                        isDisabled: isAnalyzing,
                        selectedEye: selectedEye,
                        action: camera.capturePhoto
                    )
                    .padding(
                        .bottom,
                        max(geometry.safeAreaInsets.bottom, 24) + 20
                    )
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .overlay(alignment: .top) {
                    EyeSideOverlay(eyeSide: selectedEye)
                        .padding(.top, geometry.size.height * 0.108 + 24)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
            .contentShape(Rectangle())
            .onTapGesture { location in
                focusPoint = location
                focusID = UUID()

                let devicePoint = CGPoint(
                    x: location.y / max(geometry.size.height, 1),
                    y: 1 - (location.x / max(geometry.size.width, 1))
                )
                camera.focus(at: devicePoint)
            }
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        camera.setZoom(factor: baseZoom * value)
                    }
                    .onEnded { _ in
                        baseZoom = camera.currentZoomFactor
                    }
            )
            .onAppear {
                camera.start()
                baseZoom = camera.currentZoomFactor
            }
            .onChange(of: camera.capturedImage) { _, image in
                guard let image else { return }
                onCapturedImage(image)
            }
        }
        .ignoresSafeArea()
    }
}