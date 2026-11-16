//
//  OnboardingPermission.swift
//  POC
//

import SwiftUI
import AVFoundation
import Photos

enum OnboardingPermission: CaseIterable {
    case camera
    case photos
    case attachLens

    var title: LocalizedStringKey {
        switch self {
        case .camera: return "Enable Camera Access"
        case .photos: return "Enable Photo Access"
        case .attachLens: return "Attach Optical Lens"
        }
    }

    var message: LocalizedStringKey {
        switch self {
        case .camera:
            return "Allow Glauma to access your camera to capture fundus images for screening."
        case .photos:
            return "Allow Glauma to access your Photos library to save captured images and screening reports. Glauma can add photos but cannot view your library."
        case .attachLens:
            return "Ensure the optical lens is securely attached and aligned with the main camera before starting the scan."
        }
    }

    var systemImage: String {
        switch self {
        case .camera: return "camera.fill"
        case .photos: return "photo.on.rectangle.angled"
        case .attachLens: return "camera.aperture"
        }
    }

    var illustrationLabel: LocalizedStringKey {
        switch self {
        case .camera: return "Camera illustration placeholder." //need to change
        case .photos: return "Photos illustration placeholder."
        case .attachLens: return "Optical lens illustration placeholder."
        }
    }

    var isSkippable: Bool {
        self == .photos
    }

    var isPending: Bool {
        switch self {
        case .camera:
            return AVCaptureDevice.authorizationStatus(for: .video) != .authorized
        case .photos:
            return PHPhotoLibrary.authorizationStatus(for: .addOnly) == .notDetermined
        case .attachLens:
            return true
        }
    }
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var currentIndex = 0
    @Published private(set) var isFinished = false
    @Published private(set) var isNFCDetected = false
    @Published var showsNFCInstruction = false
    @Published var showsCameraDenied = false

    let pages: [OnboardingPermission]

    private let nfcDetector = NFCFrameDetector()
    private let bypassNFCForTesting = true
    private var isRequesting = false

    init() {
        pages = OnboardingPermission.allCases.filter(\.isPending)
    }

    var currentPage: OnboardingPermission {
        pages[currentIndex]
    }

    var canAllowCurrentPermission: Bool {
        currentPage != .attachLens || isNFCDetected || bypassNFCForTesting
    }

    func startNFCScanning() {
        guard currentPage == .attachLens, !isNFCDetected, !bypassNFCForTesting else {
            return
        }

        nfcDetector.startScanning { [weak self] in
            Task { @MainActor in
                self?.isNFCDetected = true
            }
        }
    }

    func stopNFCScanning() {
        nfcDetector.stopScanning()
    }

<<<<<<< HEAD
    /// Handles the primary button for the current step.
=======
    /// Bypasses the optional NFC attachment step without requesting camera access.
    func skipNFCAttachment() {
        guard currentPage == .camera else {
            return
        }

        stopNFCScanning()
        advance()
    }

    /// Shows the system permission prompt only after the frame has been detected.
>>>>>>> origin/hifi-chaksu-papila-baseline-clean
    func allow() async {
        guard !isRequesting else { return }
        isRequesting = true
        defer { isRequesting = false }

        switch currentPage {
        case .camera:
            guard await requestCameraAccess() else {
                showsCameraDenied = true
                return
            }
        case .photos:
            // Optional: any answer (including "Don't Allow") moves on.
            if PHPhotoLibrary.authorizationStatus(for: .addOnly) == .notDetermined {
                _ = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            }
        case .attachLens:
            guard isNFCDetected || bypassNFCForTesting else {
                showsNFCInstruction = true
                return
            }
        }

        advance()
    }

    func skip() {
        guard currentPage.isSkippable else { return }
        advance()
    }

    private func requestCameraAccess() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        default:
            return false
        }
    }

    private func advance() {
        if currentIndex < pages.count - 1 {
            withAnimation {
                currentIndex += 1
            }
            startNFCScanning()
        } else {
            stopNFCScanning()
            isFinished = true
        }
    }
}
