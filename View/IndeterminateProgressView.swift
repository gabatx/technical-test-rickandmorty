//
//  IndeterminateProgressView.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import SwiftUI

// ProgressView
struct IndeterminateProgressView: View {
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ProgressView("", value: downloadAmount, total: 100)
            .frame(height: 2)
            .padding(0)

            .onReceive(timer) { _ in
                if downloadAmount < 100 {
                    downloadAmount += 2
                } else {
                    downloadAmount = 0
                }
            }
            .onAppear {
                downloadAmount = 0
            }
    }
}

struct IndeterminateProgressView_Previews: PreviewProvider {
    static var previews: some View {
        IndeterminateProgressView()
    }
}
