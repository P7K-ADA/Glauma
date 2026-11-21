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
    @State private var shutterFlashOpacity: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColors.labelPrimary
                    .ignoresSafeArea()

                CameraPreview(
                    session: camera.session,
                    onPreviewSizeChanged: camera.setPreviewSize
                )
                .ignoresSafeArea()
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
                            camera.setZoom(
                                factor: min(
                                    max(baseZoom * value, camera.minZoom),
                                    camera.maxZoom
                                )
                            )
                        }
                        .onEnded { _ in
                            baseZoom = camera.currentZoomFactor
                        }
                )
                
                Rectangle()
                    .fill(Color.black)
                    .opacity(shutterFlashOpacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                ScanCropMask()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                if let focusPoint {
                    FocusSquareView(color: tint)
                        .position(focusPoint)
                        .id(focusID)
                        .allowsHitTesting(false)
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
                        action: {
                            // Quick shutter flash
                            withAnimation(.easeOut(duration: 0.06)) {
                                shutterFlashOpacity = 0.55
                            }

                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.06
                            ) {
                                withAnimation(.easeOut(duration: 0.20)) {
                                    shutterFlashOpacity = 0
                                }
                            }

                            camera.capturePhoto()
                        }
                    )
                    .padding(
                        .bottom,
                        max(geometry.safeAreaInsets.bottom, 24) + 20
                    )
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .overlay(alignment: .top) {
                    EyeSideOverlay(eyeSide: selectedEye)
                        .padding(
                            .top,
                            geometry.size.height * 0.108 + 100
                        )
                }
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 50,
                    style: .continuous
                )
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
