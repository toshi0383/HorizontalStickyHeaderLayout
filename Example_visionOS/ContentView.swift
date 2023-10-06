//
//  ContentView.swift
//  Example_visionOS
//
//  Created by 鈴木 俊裕 on 2023/10/06.
//  Copyright © 2023 toshi0383. All rights reserved.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
