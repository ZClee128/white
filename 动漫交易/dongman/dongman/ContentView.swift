//
//  ContentView.swift
//  dongman
//
//  Created by zclee on 2026/2/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
