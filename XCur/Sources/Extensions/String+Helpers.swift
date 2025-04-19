//
//  String+Helpers.swift
//  XCur
//
//  Created by Виктор Иванов on 19.04.2025.
//

import Foundation

extension String {
    var withDotDecimalSeparator: String {
        self.replacingOccurrences(of: ",", with: ".")
    }
}
