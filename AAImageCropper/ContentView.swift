//
//  ContentView.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 24/04/2023.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        VStack() {
            ZStack {
                GeometryReader { proxy in
                    Image("a")
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .scaledToFit()
                        .clipShape(Rectangle())
                        .modifier(ScrollViewModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                }
            }
            .frame(height: UIScreen.main.bounds.height/2)
            Spacer()
        }.padding([.top])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





