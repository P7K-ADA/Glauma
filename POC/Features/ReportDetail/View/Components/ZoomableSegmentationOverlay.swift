//
//  ZoomableSegmentationOverlay.swift
//  POC
//
//  Created by Carolyn Santana on 15/11/26.
//

import SwiftUI
import UIKit

struct ZoomableSegmentationOverlay: View {
    let eye: EyeReport
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    private let minimumScale: CGFloat = 1
    private let maximumScale: CGFloat = 5

    /// Bagian gambar minimal yang harus tetap terlihat di layar saat digeser.
    private let visibleMargin: CGFloat = 80

    // MARK: - Segmentation Overlay

    private var overlayImage: UIImage? {
        guard
            let image = eye.image,
            let mask = eye.segmentationMask,
            let roi = eye.roiRectNormalized
        else {
            return nil
        }

        return SegmentationOverlay.makeImage(
            from: mask,
            width: eye.maskWidth,
            height: eye.maskHeight,
            canvasSize: image.size,
            roiRectNormalized: roi
        )
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black
                    .opacity(0.55)
                    .ignoresSafeArea()

                // Image (hanya tampilan, tidak menerima touch)
                imageViewer(in: geometry.size)
                    .allowsHitTesting(false)

                // Layer khusus gesture (di atas gambar, di bawah tombol close)
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        toggleZoom()
                    }
                    .highPriorityGesture(dragGesture(in: geometry.size))
                    .simultaneousGesture(magnificationGesture(in: geometry.size))

                // Close Button
                closeButton
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topTrailing
                    )
                    .padding(
                        .top,
                        max(geometry.safeAreaInsets.top, 50) + 12
                    )
                    .padding(.trailing, 24)
                    .zIndex(2)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .ignoresSafeArea()
    }

    // MARK: - Image Viewer

    @ViewBuilder
    private func imageViewer(in size: CGSize) -> some View {
        if let image = eye.image {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()

                if let overlayImage {
                    Image(uiImage: overlayImage)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(
                width: size.width - 40,
                height: size.height - 100
            )
            .scaleEffect(scale)
            .offset(offset)
            .frame(
                width: size.width,
                height: size.height
            )
        } else {
            Text("Foto tidak tersedia")
                .foregroundStyle(.white.opacity(0.7))
                .frame(width: size.width, height: size.height)
        }
    }

    // MARK: - Drag Gesture

    private func dragGesture(in size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let proposed = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
                offset = clamped(proposed, in: size)
            }
            .onEnded { value in
                let proposed = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
                let final = clamped(proposed, in: size)
                offset = final
                lastOffset = final
            }
    }

    // MARK: - Magnification Gesture

    private func magnificationGesture(in size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = lastScale * value
                scale = min(max(newScale, minimumScale), maximumScale)
            }
            .onEnded { _ in
                lastScale = scale

                if scale <= minimumScale {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        resetZoom()
                    }
                }
            }
    }

    // MARK: - Clamping (longgar)

    /// Batas geser dibuat longgar: gambar bebas dipindah, tapi
    /// minimal `visibleMargin` point tetap terlihat di layar.
    private func clamped(_ proposed: CGSize, in size: CGSize) -> CGSize {
        let imageWidth = (size.width - 40) * scale
        let imageHeight = (size.height - 100) * scale

        let maxX = max(0, (imageWidth + size.width) / 2 - visibleMargin)
        let maxY = max(0, (imageHeight + size.height) / 2 - visibleMargin)

        return CGSize(
            width: min(max(proposed.width, -maxX), maxX),
            height: min(max(proposed.height, -maxY), maxY)
        )
    }

    // MARK: - Close Button

    private var closeButton: some View {
        Button(action: onDismiss) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 38, height: 38)
                .background(.regularMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .strokeBorder(
                            Color.white.opacity(0.15),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Tutup preview")
    }

    // MARK: - Zoom Controls

    private func toggleZoom() {
        withAnimation(.easeInOut(duration: 0.2)) {
            if scale > minimumScale {
                resetZoom()
            } else {
                scale = 2.5
                lastScale = 2.5
            }
        }
    }

    private func resetZoom() {
        scale = minimumScale
        lastScale = minimumScale

        offset = .zero
        lastOffset = .zero
    }
}
