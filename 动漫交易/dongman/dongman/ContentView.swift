//
//  ContentView.swift
//  dongman
//
//  Created by zclee on 2026/2/28.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasAcceptedEULA") private var hasAcceptedEULA: Bool = false

    var body: some View {
        MainTabView()
            .fullScreenCover(isPresented: .init(get: { !hasAcceptedEULA }, set: { _ in })) {
                EULAView()
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
