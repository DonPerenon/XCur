//
//  UIKit+Helpers.swift
//  XCur
//
//  Created by Виктор Иванов on 19.04.2025.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
