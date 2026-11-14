//
//  CDRAssesments.swift
//  POC
//
//  Created by Harley Ganisson on 20/10/26.
//

import SwiftUI

/// Cut-offs between screening categories.
/// PLACEHOLDER VALUES: confirm with an ophthalmologist before release.
struct CDRThresholds: Equatable {
    var suspectFrom: Double = 0.5
    var highRiskFrom: Double = 0.7

    static let standard = CDRThresholds()
}

enum CDRStatus: Int, Comparable {
    case unavailable = 0
    case normal
    case suspect
    case highRisk

    init(cdr: Double?, thresholds: CDRThresholds = .standard) {
        guard let cdr else {
            self = .unavailable
            return
        }
        if cdr >= thresholds.highRiskFrom {
            self = .highRisk
        } else if cdr >= thresholds.suspectFrom {
            self = .suspect
        } else {
            self = .normal
        }
    }

    static func < (lhs: CDRStatus, rhs: CDRStatus) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var label: String {
        switch self {
        case .unavailable: return "Tidak tersedia"
        case .normal: return "Dalam batas"
        case .suspect, .highRisk: return "Perlu perhatian"
        }
    }

    var tint: Color {
        switch self {
        case .unavailable: return AppColors.labelSecondary
        case .normal: return AppColors.normal
        case .suspect, .highRisk: return AppColors.suspect
        }
    }

    var nextStepTitle: String {
        switch self {
        case .unavailable: return "Hasil Belum Tersedia"
        case .normal: return "Pemeriksaan Rutin"
        case .suspect, .highRisk: return "Indikasi Rasio vCDR Meningkat"
        }
    }

    var nextStepBody: String {
        switch self {
        case .unavailable:
            return "Ambil ulang foto mata untuk mendapatkan hasil pemeriksaan."
        case .normal:
            return "Lanjutkan pemeriksaan mata secara rutin sesuai anjuran dokter."
        case .suspect:
            return "Jadwalkan pemeriksaan mata lebih lanjut dan konsultasikan hasil kedua mata dengan dokter spesialis."
        case .highRisk:
            return "Jadwalkan pemeriksaan mata lebih lanjut dan konsultasikan hasil kedua mata dengan dokter spesialis."
        }
    }
}
