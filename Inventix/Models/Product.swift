//
//  Product.swift
//  Inventix
//
//  Created by Khanh Chung on 3/28/24.
//

import Foundation

struct Product: Identifiable, Equatable, Hashable {
    var name: String
    var description = ""
    var categoryId: UUID
    var price: Decimal
    var sku: String
    var minStock: Int
    var imageUrl: String
    var expired = Date()
    
    let id = UUID()
    
    func daysBeforeExpired() -> Int {
        Calendar.current.dateComponents([.day], from: expired, to: Date.now).day!
    }
    
    static let example: [Product] = [
        Product(name: "Quantix Capacitor",
                description: "State-of-the-art energy storage device that harnesses quantum principles to provide unprecedented power density and fast recharge capabilities.",
                categoryId: Category.example[0].id,
                price: Decimal(string: "620.00") ?? 0,
                sku: "ERO-921",
                minStock: 500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/R7EsuQbHunkxH2Ff7myK.png"),
        
        Product(name: "OmniGlide Transmitter",
                description: "Advanced wireless communication technology, enabling seamless data transmission across vast distances with minimal latency.",
                categoryId: Category.example[1].id,
                price: Decimal(string: "780.00") ?? 0,
                sku: "ERO-CC1",
                minStock: 2500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/m07LDrMVvXbuv53I7ly2.png"),
        
        Product(name: "Pulse Processor",
                description: "Signal amplification with its cutting-edge spectral analysis algorithms, delivering crystal-clear audio and unmatched fidelity.",
                categoryId: Category.example[2].id,
                price: Decimal(string: "776.00") ?? 0,
                sku: "ERO-CV1",
                minStock: 5000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/mJqvJq2agaypGxgLPn9y.png"),
        
        Product(name: "Wave Resonator",
                description: "Neurocomputing marvel, mimicking the complexity of the human brain to process and analyze vast amounts of data with lightning-fast speed.",
                categoryId: Category.example[3].id,
                price: Decimal(string: "377.00") ?? 0,
                sku: "ERO-LI1",
                minStock: 2500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/hXA1EjzahHpZwcuYlirB.png"),
        
        Product(name: "Nanofiber Tube",
                description: "Components that enable ultra-compact and highly efficient electronic circuits, revolutionizing miniaturization in the field of electronics.",
                categoryId: Category.example[4].id,
                price: Decimal(string: "997.00") ?? 0,
                sku: "ERO-LC1",
                minStock: 3500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/hqV7lIkgf7GKL3duJSlo.png"),
        
        Product(name: "Circuitbox",
                description: "An intense and precisely controllable beam of light that outshines conventional solutions.",
                categoryId: Category.example[4].id,
                price: Decimal(string: "24.00") ?? 0,
                sku: "ERO-WG1",
                minStock: 2000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/aUB5oBbRpDWUCWdolWQj.png"),
        
        Product(name: "Morphic Transistor",
                description: "Plasma-based magnetic fields to achieve unprecedented energy efficiency and compactness in energy storage and transfer systems.",
                categoryId: Category.example[0].id,
                price: Decimal(string: "693.00") ?? 0,
                sku: "ERO-CS1",
                minStock: 1000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/8vaGMt5c6TckVD4nkduy.png"),
        
        Product(name: "HyperLux Diode",
                description: "Resonator utilizes quantum entanglement to create stable and reliable oscillations, making it a cornerstone of advanced quantum computing and communication systems.",
                categoryId: Category.example[3].id,
                price: Decimal(string: "263.00") ?? 0,
                sku: "SDI-989",
                minStock: 1500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/Z1NivEP9kiOxcJKs948A.png"),
        
        Product(name: "Drive Amplifier",
                description: "Ipsum duis velit laborum non culpa. Irure excepteur elit cupidatat culpa do ipsum duis laboris ipsum commodo ipsum. Sit et veniam in velit non irure irure veniam sit nulla deserunt irure laboris. Reprehenderit anim cillum dolore anim officia amet in ad pariatur consequat. Proident qui eiusmod labore velit quis et commododolore ipsum reprehenderit sit elit consequat voluptate eiusmod tempor aliquip.",
                categoryId: Category.example[5].id,
                price: Decimal(string: "380.00") ?? 0,
                sku: "DSSO-790",
                minStock: 2000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/SiFIpq1jrZkulqSca9dA.png"),
        
        Product(name: "Gyro Actuator",
                description: "Secure data storage and processing by employing advanced encryption algorithms and impenetrable physical barriers to safeguard against cyber threats.",
                categoryId: Category.example[7].id,
                price: Decimal(string: "355.00") ?? 0,
                sku: "DSF-DD0",
                minStock: 3500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/KkRAlfLrTs0dNZ4mBG9D.png"),
        
        Product(name: "Sync Stabilizer",
                description: "Advanced power management solution that regulates and stabilizes energy flow, ensuring a steady supply of electricity to critical systems.",
                categoryId: Category.example[8].id,
                price: Decimal(string: "1043.00") ?? 0,
                sku: "WID-WI9",
                minStock: 2000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/8hD5yH8zZwGDWB3zoVRt.png"),
        
        Product(name: "Core Inductor",
                description: "A highly adaptable material composed of exceptionally thin nanofibers, enabling its integration into numerous industries, from high-performance textiles to advanced filtration systems.",
                categoryId: Category.example[6].id,
                price: Decimal(string: "568.00") ?? 0,
                sku: "DSSO-790",
                minStock: 1500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/nbgqKgPY9QW99ZH9zTov.png"),
        
        Product(name: "Quantum Relay",
                description: "Cutting-edge technology for transmitting data across quantum entangled particles, ensuring secure and instantaneous communication.",
                categoryId: Category.example[1].id,
                price: Decimal(string: "767.00") ?? 0,
                sku: "SDI-966",
                minStock: 1000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/sHMvlihrP8weChdytnyj.png"),
        
        Product(name: "NanoProcessor",
                description: "Miniaturized computing powerhouse capable of executing complex algorithms with unparalleled efficiency and speed.",
                categoryId: Category.example[2].id,
                price: Decimal(string: "736.00") ?? 0,
                sku: "HRO-CS1",
                minStock: 2000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/eAWESBLJyueYyB07WUS5.png"),
        
        Product(name: "Photon Amplifier",
                description: "Amplifies and directs photon emissions for various applications in telecommunications, optical computing, and laser technology.",
                categoryId: Category.example[5].id,
                price: Decimal(string: "524.00") ?? 0,
                sku: "ERO-WG2",
                minStock: 3000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/dnC3We4b8RoJJuw1QwQn.png"),
        
        Product(name: "Data Encryptor",
                description: "Advanced encryption device that secures sensitive data with military-grade algorithms, protecting against unauthorized access and cyber threats.",
                categoryId: Category.example[7].id,
                price: Decimal(string: "943.00") ?? 0,
                sku: "ERO-CC1",
                minStock: 2500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/1mIjr1MAjTShpBJmzur1.png"),
        
        Product(name: "Power Grid Optimizer",
                description: "AI-driven system for optimizing power distribution grids, reducing energy wastage and enhancing overall efficiency.",
                categoryId: Category.example[8].id,
                price: Decimal(string: "474.00") ?? 0,
                sku: "WIE-WI9",
                minStock: 1500,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/UjykZZ7EpWWs3xJHa8cq.png"),
        
        Product(name: "Quantum Sensor",
                description: "Utilizes quantum principles to detect and analyze minute changes in environmental factors, enabling advanced monitoring and control systems.",
                categoryId: Category.example[2].id,
                price: Decimal(string: "687.00") ?? 0,
                sku: "YUO-89F",
                minStock: 3000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/2ivPSNWndZlSKFFiDDiY.png"),
        
        Product(name: "Graphene Capacitor",
                description: "Revolutionary energy storage solution utilizing graphene's unique properties for high-capacity and rapid charging applications.",
                categoryId: Category.example[0].id,
                price: Decimal(string: "328.00") ?? 0,
                sku: "SDI-766",
                minStock: 4000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/ZA6P1j5Cdys9SowChIwZ.png"),
        
        Product(name: "Bio-Sensing Module",
                description: "Integrates biological sensing technology for real-time monitoring of physiological data, facilitating advancements in healthcare and biotechnology.",
                categoryId: Category.example[2].id,
                price: Decimal(string: "567.00") ?? 0,
                sku: "ERO-231",
                minStock: 2000,
                imageUrl: "https://storage.googleapis.com/glide-prod.appspot.com/uploads-v2/YGvI36VoQe5mJNelMBS1-template-builder/pub/ewyr9mrwaJBfASQqmVEj.png"),
    ]
}
