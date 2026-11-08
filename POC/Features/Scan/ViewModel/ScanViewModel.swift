import PhotosUI
import SwiftUI
import UIKit

@MainActor
final class ScanViewModel: ObservableObject {
    let camera = CameraService()

    @Published var selectedEye: EyeSide = .left
    @Published var selectedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem?
    @Published private(set) var leftImage: UIImage?
    @Published private(set) var rightImage: UIImage?
    @Published private(set) var leftResult: SegmentationResult?
    @Published private(set) var rightResult: SegmentationResult?
    @Published private(set) var isReviewing = false
    @Published private(set) var isAnalyzing = false
    @Published private(set) var analysisErrorMessage: String?
    @Published private(set) var completedSession: ScreeningSession?
    @Published var showReport = false
    @Published var errorMessage: String?

    private var analysisTask: Task<Void, Never>?
    private var analysisID = UUID()

    var isLastEye: Bool {
        selectedEye == .right ? leftImage != nil : rightImage != nil
    }

    func handleCapturedImage(_ image: UIImage) {
        camera.setTorch(enabled: false)
        camera.stop()
        prepareReview(with: image)
    }

    func loadGalleryImage(_ item: PhotosPickerItem) async {
        do {
            guard
                let data = try await item.loadTransferable(type: Data.self),
                let image = UIImage(data: data)
            else {
                errorMessage = "Couldn't load that image. Please choose another."
                return
            }

            camera.stop()
            prepareReview(with: image)
        } catch {
            errorMessage = "Couldn't load the selected image: \(error.localizedDescription)"
        }
    }

    func retakeCurrentEye() {
        analysisTask?.cancel()
        analysisTask = nil
        analysisID = UUID()

        if selectedEye == .right {
            rightImage = nil
            rightResult = nil
        } else {
            leftImage = nil
            leftResult = nil
        }

        selectedImage = nil
        selectedItem = nil
        analysisErrorMessage = nil
        isAnalyzing = false
        isReviewing = false
        camera.start()
    }

    func chooseAnotherImage() {
        selectedItem = nil
    }

    func useEditedImage(_ image: UIImage) {
        guard selectedImage != nil, analysisErrorMessage == nil else { return }
        commitCurrentImage()
    }

    func commitCurrentImage() {
        guard
            let image = selectedImage,
            !isAnalyzing,
            analysisErrorMessage == nil
        else {
            return
        }

        let result: SegmentationResult?
        if selectedEye == .left {
            result = leftResult
            leftImage = image
        } else {
            result = rightResult
            rightImage = image
        }

        guard result != nil else {
            return
        }

        if isLastEye {
            saveCurrentSession()
        } else {
            selectedEye = selectedEye == .right ? .left : .right
            selectedImage = nil
            analysisErrorMessage = nil
            isReviewing = false
            camera.start()
        }
    }

    func resetScan() {
        analysisTask?.cancel()
        analysisTask = nil
        analysisID = UUID()
        selectedImage = nil
        selectedItem = nil
        isReviewing = false
        leftImage = nil
        rightImage = nil
        leftResult = nil
        rightResult = nil
        selectedEye = .left
        isAnalyzing = false
        analysisErrorMessage = nil
        completedSession = nil
        showReport = false
        camera.start()
    }

    func stopCamera() {
        camera.stop()
    }

    func dismissError() {
        Task { @MainActor [weak self] in
            self?.errorMessage = nil
        }
    }

    private func prepareReview(with image: UIImage) {
        analysisTask?.cancel()
        let newAnalysisID = UUID()
        analysisID = newAnalysisID
        selectedImage = image
        selectedItem = nil
        analysisErrorMessage = nil
        isReviewing = false
        isAnalyzing = true

        analysisTask = Task { [weak self] in
            await self?.analyzeCapturedImage(image, analysisID: newAnalysisID)
        }
    }

    private func analyzeCapturedImage(
        _ image: UIImage,
        analysisID: UUID
    ) async {
        defer {
            if self.analysisID == analysisID {
                isAnalyzing = false
                isReviewing = true
                analysisTask = nil
            }
        }

        do {
            let gatekeeper = try GatekeeperService()
            let gatekeeperResult = try gatekeeper.evaluate(image: image)
            guard !Task.isCancelled, self.analysisID == analysisID else { return }

            if let issue = gatekeeperResult.issue {
                analysisErrorMessage = issue.message
                return
            }

            let segmentation = try ImageInferenceService()
            let result = try segmentation.predict(image: image)
            guard !Task.isCancelled, self.analysisID == analysisID else { return }

            if selectedEye == .left {
                leftResult = result
            } else {
                rightResult = result
            }
        } catch is CancellationError {
            return
        } catch {
            guard self.analysisID == analysisID else { return }
            analysisErrorMessage = modelErrorMessage(error, eye: selectedEye)
        }
    }

    private func saveCurrentSession() {
        let sessionID = UUID()

        let leftEye = EyeExaminationRecord(
            sessionID: sessionID,
            eyeSide: .left,
            image: leftImage,
            segmentationResult: leftResult,
            isDummy: leftImage == nil
        )

        let rightEye = EyeExaminationRecord(
            sessionID: sessionID,
            eyeSide: .right,
            image: rightImage,
            segmentationResult: rightResult,
            isDummy: rightImage == nil
        )

        completedSession = ScreeningSession(
            id: sessionID,
            examDate: .now,
            status: .completed,
            leftEye: leftEye,
            rightEye: rightEye
        )
        showReport = true
    }

    private func modelErrorMessage(_ error: Error, eye: EyeSide) -> String {
        let eyeName = eye == .left ? "left eye" : "right eye"
        return "The model was unable to analyze the \(eyeName): \(error.localizedDescription)"
    }
}
