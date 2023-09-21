//
//  Extensions.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
