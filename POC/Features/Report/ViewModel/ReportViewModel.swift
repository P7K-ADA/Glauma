//
//  ReportViewModel.swift
//  POC
//
//  Created by Harley Ganisson on 20/10/26.
//

import SwiftUI

@MainActor
final class ReportViewModel: ObservableObject {
    let report: ReportData
    @Published private(set) var isExporting = false
    @Published private(set) var hasExported = false
    @Published var showingExportSuccess = false
    @Published var showingUnsavedExportAlert = false
    @Published var exportError: String?

    init(report: ReportData) {
        self.report = report
    }

    func exportReport() {
        guard !isExporting else { return }

        isExporting = true
        exportError = nil

        Task {
            do {
                let items = try ReportExportService.render(report)
                try await ReportExportService.saveToPhotos(items)
                isExporting = false
                hasExported = true
                showingExportSuccess = true
            } catch {
                isExporting = false
                exportError = error.localizedDescription
            }
        }
    }
}
