//
//  QRCodeView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/5/24.
//

import SwiftUI

struct QRCodeView: View {
    var text: String
    
    var body: some View {
        VStack(spacing: 0) {
            QRCodeGenerator().generateBarcode(text: text)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 160, alignment: .center)
            Text(text)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    QRCodeView(text: "ABC-123")
}
