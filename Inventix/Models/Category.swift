//
//  Category.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import Foundation

struct Category: Identifiable, Equatable, Hashable {
    let id = UUID()
    var name: String
    var description: String?
    
    static let example: [Category] = [
        .init(name: "Energy Storage", description: "Products in this category focus on storing and managing energy efficiently, often utilizing advanced materials or principles such as quantum mechanics to enhance power density, recharge speed, and overall performance."),
        .init(name: "Communication", description: "This category includes products that facilitate the transmission of data and information, typically through wireless or wired channels. These products often prioritize speed, reliability, and low latency to enable seamless communication across various devices and networks."),
        .init(name: "Signal Processing", description: "Products in this category are designed to manipulate, analyze, and enhance signals, such as audio, video, or data streams. They may incorporate cutting-edge algorithms and technologies to amplify signals, extract relevant information, or remove noise, resulting in clearer and more accurate outputs."),
        .init(name: "Computing", description: "This category encompasses products related to computing hardware, software, and systems. These products may include components like processors, memory modules, and storage devices, as well as software applications and algorithms that enable data processing, analysis, and computation. They aim to improve computational speed, efficiency, and accuracy for various applications and industries."),
        .init(name: "Electronics", description: "Electronics category description."),
        .init(name: "Miscellaneous", description: "Miscellaneous category description."),
        .init(name: "Material Science", description: "Material Science category description."),
        .init(name: "Security", description: "Security category description"),
        .init(name: "Energy Management", description: "Energy Management category description.")
    ]
}
