import SwiftUI

struct ScanZoomControl: View {
    @ObservedObject var camera: CameraService

    @State private var dragStartZoom: CGFloat?

    private var maximumVisibleZoom: CGFloat {
        min(camera.maxZoom, 3)
    }

    private var selectedIndex: Int {
        let value = camera.currentZoomFactor.rounded()
        return min(max(Int(value) - 1, 0), 2)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    ForEach(1...3, id: \.self) { zoom in
                        Text("\(zoom)x")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(
                                zoom - 1 == selectedIndex
                                    ? AppColors.suspect
                                    : AppColors.white.opacity(0.62)
                            )
                            .frame(maxWidth: .infinity)
                            .background {
                                if zoom - 1 == selectedIndex {
                                    Circle()
                                        .fill(AppColors.labelPrimary)
                                        .frame(width: 38, height: 38)
                                }
                            }
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(height: 50)
            .scanGlassCapsule()
            .contentShape(Capsule())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if dragStartZoom == nil {
                            dragStartZoom = camera.currentZoomFactor
                        }

                        let change = value.translation.width / max(geometry.size.width, 1) * 2
                        let zoom = min(
                            max(dragStartZoom! + change, camera.minZoom),
                            maximumVisibleZoom
                        )
                        camera.setZoom(factor: zoom)
                    }
                    .onEnded { _ in
                        dragStartZoom = nil
                    }
            )
        }
        .frame(width: 154, height: 44)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Camera zoom")
        .accessibilityValue("\(camera.currentZoomFactor, specifier: "%.1f") times magnification")
        .accessibilityHint("Drag horizontally to change zoom.")
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
            background(.ultraThinMaterial, in: Capsule())
                .overlay {
                    Capsule()
                        .fill(AppColors.labelPrimary.opacity(0.36))
                }
                .overlay {
                    Capsule()
                        .stroke(AppColors.white.opacity(0.35), lineWidth: 1)
                }
        }
    }
}
