
import SwiftUI

struct ScanZoomControl: View {

    @ObservedObject var camera: CameraService

    private let zoomStops: [CGFloat] = [1, 3, 5]
    private let circleSize: CGFloat = 38

    private var maximumVisibleZoom: CGFloat {
        min(camera.maxZoom, 5)
    }

    private var currentZoom: CGFloat {
        min(
            max(camera.currentZoomFactor, camera.minZoom),
            maximumVisibleZoom
        )
    }

    // Highlight follows the actual zoom factor.
    private var selectedIndex: Int {
        if currentZoom >= 5 {
            return 2
        }

        if currentZoom >= 3 {
            return 1
        }

        return 0
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 4) {

                ForEach(
                    Array(zoomStops.enumerated()),
                    id: \.offset
                ) { index, zoom in

                    Button {
                        camera.setZoom(
                            factor: min(zoom, maximumVisibleZoom)
                        )
                    } label: {
                        Text(buttonLabel(for: index))
                            .font(.system(size: 11, weight: .semibold))
                            .monospacedDigit()
                            .foregroundStyle(
                                selectedIndex == index
                                    ? AppColors.zoomButtons
                                    : AppColors.white.opacity(0.75)
                            )
                            .frame(
                                width: circleSize,
                                height: circleSize
                            )
                            .background {
                                if selectedIndex == index {
                                    Circle()
                                        .fill(Color.black)
                                }
                            }
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(zoom > camera.maxZoom)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("\(Int(zoom)) times zoom")
                }
            }
            .padding(.horizontal, 4)
            .frame(height: 50)
            .scanGlassCapsule()
            .contentShape(Capsule())

            // Prioritize dragging over the internal Button gesture.
            .highPriorityGesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { value in

                        // Ignore vertical gestures.
                        guard abs(value.translation.width) >
                              abs(value.translation.height) else {
                            return
                        }

                        let horizontalPadding = circleSize / 2 + 8

                        let usableWidth = max(
                            geometry.size.width - horizontalPadding * 2,
                            1
                        )

                        let position = min(
                            max(
                                value.location.x - horizontalPadding,
                                0
                            ),
                            usableWidth
                        )

                        let progress = position / usableWidth

                        let zoom = camera.minZoom +
                            progress * (
                                maximumVisibleZoom - camera.minZoom
                            )

                        camera.setZoom(factor: zoom)
                    }
            )
        }
        .frame(width: 140, height: 44)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Zoom control")
        .accessibilityHint("Select a zoom level or drag horizontally to adjust the camera zoom.")
    }

    private func buttonLabel(for index: Int) -> String {
        if selectedIndex == index {
            return String(
                format: "%.1fx",
                Double(currentZoom)
            )
        }

        return "\(Int(zoomStops[index]))x"
    }
}

private extension View {

    @ViewBuilder
    func scanGlassCapsule() -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(
                .regular
                    .tint(AppColors.labelPrimary.opacity(0.34))
                    .interactive(),
                in: Capsule()
            )
        } else {
            background(
                .ultraThinMaterial,
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .fill(
                        AppColors.labelPrimary.opacity(0.36)
                    )
            }
            .overlay {
                Capsule()
                    .stroke(
                        AppColors.white.opacity(0.35),
                        lineWidth: 1
                    )
            }
        }
    }
}
