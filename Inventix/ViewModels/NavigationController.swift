//
//  NavigationController.swift
//  Inventix
//
//  Created by Tri Tat on 5/15/24.
//

import Foundation
class NavigationController: ObservableObject {
    @Published var shouldReturnToCategoryList: Bool = false
    func navigateBackToCategoryList() {
            shouldReturnToCategoryList = true
        }
}
