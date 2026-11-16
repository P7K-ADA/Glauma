//
//  GlaumaLocalization.swift
//  POC
//
//  Created by Carolyn Santana on 16/11/26.
//


import Foundation

/// Centralized user-facing copy for model and preprocessing results.
/// English is the development language; add Indonesian translations in Localizable.xcstrings.
enum GlaumaLocalization {

    static func message(for code: String) -> String {
        switch code {
        case "MODEL_NOT_FOUND":
            return NSLocalizedString("analysis.error.model_not_found", tableName: nil, bundle: .main, value: "The segmentation model could not be found.", comment: "")
        case "INVALID_IMAGE":
            return NSLocalizedString("analysis.error.invalid_image", tableName: nil, bundle: .main, value: "The image could not be read. Please capture the image again.", comment: "")
        case "INVALID_INPUT_SHAPE":
            return NSLocalizedString("analysis.error.invalid_input_shape", tableName: nil, bundle: .main, value: "The image could not be prepared for analysis.", comment: "")
        case "INVALID_OUTPUT_SHAPE":
            return NSLocalizedString("analysis.error.invalid_output_shape", tableName: nil, bundle: .main, value: "The model returned an unexpected output format.", comment: "")
        case "EMPTY_MASK":
            return NSLocalizedString("analysis.error.empty_mask", tableName: nil, bundle: .main, value: "The model could not identify the optic disc or optic cup.", comment: "")
        case "NO_FUNDUS":
            return NSLocalizedString("analysis.error.no_fundus", tableName: nil, bundle: .main, value: "The fundus area is not clearly visible. Position the lens directly in front of the eye and capture the image again.", comment: "")
        case "OVEREXPOSED":
            return NSLocalizedString("analysis.error.overexposed", tableName: nil, bundle: .main, value: "The image is too bright. Reduce the lighting or flash, adjust the lens position, and try again.", comment: "")
        case "UNDEREXPOSED":
            return NSLocalizedString("analysis.error.underexposed", tableName: nil, bundle: .main, value: "The image is too dark. Improve the lighting and capture the image again.", comment: "")
        case "GLARE":
            return NSLocalizedString("analysis.error.glare", tableName: nil, bundle: .main, value: "Light reflections are obscuring the fundus area. Adjust the lens angle or lighting and try again.", comment: "")
        case "BLUR":
            return NSLocalizedString("analysis.error.blur", tableName: nil, bundle: .main, value: "The image is out of focus. Stabilize the phone and lens, refocus, and capture the image again.", comment: "")
        case "LOW_CONTRAST":
            return NSLocalizedString("analysis.error.low_contrast", tableName: nil, bundle: .main, value: "The image has insufficient contrast. Check the focus and lighting, then try again.", comment: "")
        case "DISC_NOT_FOUND":
            return NSLocalizedString("analysis.error.disc_not_found", tableName: nil, bundle: .main, value: "The optic disc could not be detected. Ensure the fundus is fully visible and in focus, then try again.", comment: "")
        case "PREPROCESS_FAIL":
            return NSLocalizedString("analysis.error.preprocess_fail", tableName: nil, bundle: .main, value: "The image could not be processed. Please capture the fundus image again.", comment: "")
        case "ROI_METADATA_MISSING":
            return NSLocalizedString("analysis.error.roi_metadata_missing", tableName: nil, bundle: .main, value: "Optic disc ROI coordinates are unavailable. Please process the image again.", comment: "")
        case "ROI_METADATA_INVALID":
            return NSLocalizedString("analysis.error.roi_metadata_invalid", tableName: nil, bundle: .main, value: "The optic disc ROI coordinates are invalid. Please process the image again.", comment: "")
        case "MODEL_OUTPUT":
            return NSLocalizedString("analysis.error.model_output", tableName: nil, bundle: .main, value: "The model output does not match the expected format.", comment: "")
        case "EMPTY_DISC_MASK":
            return NSLocalizedString("analysis.error.empty_disc_mask", tableName: nil, bundle: .main, value: "The model could not generate a valid optic disc segmentation. Please capture the image again.", comment: "")
        case "EMPTY_CUP_MASK":
            return NSLocalizedString("analysis.error.empty_cup_mask", tableName: nil, bundle: .main, value: "The model could not generate a valid optic cup segmentation. Please capture the image again.", comment: "")
        case "LOW_SEGMENTATION_CONFIDENCE":
            return NSLocalizedString("analysis.error.low_confidence", tableName: nil, bundle: .main, value: "The segmentation result is not sufficiently reliable. Please capture another image with better positioning and focus.", comment: "")
        case "INVALID_SEGMENTATION":
            return NSLocalizedString("analysis.error.invalid_segmentation", tableName: nil, bundle: .main, value: "The segmentation result did not pass quality validation. Please capture the image again.", comment: "")
        default:
            return NSLocalizedString("analysis.error.generic", tableName: nil, bundle: .main, value: "The image could not be processed. Please try again.", comment: "")
        }
    }

    static func warning(for code: String) -> String {
        switch code {
        case "LOW_SHARPNESS":
            return NSLocalizedString("analysis.warning.low_sharpness", tableName: nil, bundle: .main, value: "The image appears slightly blurry. Please review the segmentation result carefully.", comment: "")
        case "FOV_CROP_SKIPPED":
            return NSLocalizedString("analysis.warning.fov_crop_skipped", tableName: nil, bundle: .main, value: "Automatic field-of-view cropping was skipped.", comment: "")
        case "OD_HOLE_FILL_EXCESSIVE":
            return NSLocalizedString("analysis.warning.disc_hole_fill", tableName: nil, bundle: .main, value: "The optic disc segmentation required extensive hole filling.", comment: "")
        case "OC_HOLE_FILL_EXCESSIVE":
            return NSLocalizedString("analysis.warning.cup_hole_fill", tableName: nil, bundle: .main, value: "The optic cup segmentation required extensive hole filling.", comment: "")
        case "OC_TOUCHES_BACKGROUND":
            return NSLocalizedString("analysis.warning.cup_background", tableName: nil, bundle: .main, value: "The optic cup segmentation may extend beyond the optic disc boundary.", comment: "")
        default:
            return NSLocalizedString("analysis.warning.generic", tableName: nil, bundle: .main, value: "The analysis produced a warning that should be reviewed.", comment: "")
        }
    }
}
