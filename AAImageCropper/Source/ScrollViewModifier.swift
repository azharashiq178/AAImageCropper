//
//  ScrollViewModifier.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 02/05/2023.
//

import SwiftUI

struct ScrollViewModifier: ViewModifier {
    private var contentSize: CGSize
    private var min: CGFloat = 1.0
    private var max: CGFloat = 3.0
    @State var currentScale: CGFloat = 1.0
    @State var isGridHidden: Bool = true
    @State var isPinching : Bool = false

    init(contentSize: CGSize) {
        self.contentSize = contentSize
    }
    
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            if currentScale <= min { currentScale = max } else
            if currentScale >= max { currentScale = min } else {
                currentScale = ((max - min) * 0.5 + min) < currentScale ? max : min
            }
            isGridHidden = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.isGridHidden = true
            }
        }
    }
    @GestureState private var dragOffset: CGSize = .zero
    
    
    func body(content: Content) -> some View {
        ZStack {
            ScrollView([.horizontal, .vertical]) {
                content
                    .background(Color.blue)
                    .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
                    .modifier(PinchToZoom(minScale: min, maxScale: max, scale: $currentScale, isPinching: $isPinching))
                ScrollViewOffsetReader()
                    .onScrollingStarted {
                        self.isGridHidden = false
                    }
                    .onScrollingFinished {
                        self.isGridHidden = true
                    }
            }
            .gesture(doubleTapGesture)
            .animation(.easeInOut, value: currentScale)
            if isPinching || !isGridHidden {
                AAGridView()
            }
        }

    }
}
