//
//  OnboardingView.swift
//  POC
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.openURL) private var openURL
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            AppColors.white
                .ignoresSafeArea()

            OnboardingPermissionPage(
                permission: viewModel.currentPage,
                pageIndex: viewModel.currentIndex,
                pageCount: viewModel.pages.count,
                isAllowEnabled: viewModel.canAllowCurrentPermission,
                onAllow: { Task { await viewModel.allow() } },
                onSkip: { viewModel.skip() }
            )
            .id(viewModel.currentIndex)
            .transition(.opacity)
        }
        .onAppear {
            viewModel.startNFCScanning()
        }
        .onDisappear {
            viewModel.stopNFCScanning()
        }
        .alert("Camera access is off", isPresented: $viewModel.showsCameraDenied) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Glauma needs the camera to scan. Turn on camera access in Settings, then tap Continue again.")
        }
        .alert("Please attach frame", isPresented: $viewModel.showsNFCInstruction) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Attach the NTAG213 lens frame to the back of your iPhone, then tap Continue again.")
        }
        .onChange(of: viewModel.isFinished) { _, finished in
            if finished {
                onFinish()
            }
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
