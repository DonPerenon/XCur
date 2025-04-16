//
//  CurrencyRate.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import Foundation


// модель для информации о валюте

struct CurrencyRate: Identifiable, Codable, Equatable {
    var id: String { code }
    
    let code: String // usd, rub
    let rate: Double // курс по отношению к "базовой" валюте
}
