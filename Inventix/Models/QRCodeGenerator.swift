//
//  QRCodeGenerator.swift
//  Inventix
//
//  Created by Khanh Chung on 4/5/24.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    let context = CIContext()

    func generateBarcode(text: String) -> Image {
        let generator = CIFilter.qrCodeGenerator()
        generator.message = Data(text.utf8)
        
        let transform = CGAffineTransform(scaleX: 5, y: 5)
        if let outputImage = generator.outputImage?.transformed(by: transform),
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {

            let uiImage = UIImage(cgImage: cgImage)

            return Image(uiImage: uiImage)
        }

        return Image(systemName: "barcode")
    }
}
