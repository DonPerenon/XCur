//
//  ViewModelProtocol.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import Foundation

@MainActor
protocol ViewModel: ObservableObject {
    
    associatedtype State: Equatable
    associatedtype Action: Equatable
    
    var state: State { get set }
    
    func handle(action: Action)
    
}
