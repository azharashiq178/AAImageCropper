//
//  ScrollViewOffsetReader.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 02/05/2023.
//

import SwiftUI
import Combine

struct ScrollViewOffsetReader: View {
    private let onScrollingStarted: () -> Void
    private let onScrollingFinished: () -> Void
    
    private let detector: CurrentValueSubject<CGFloat, Never>
    private let publisher: AnyPublisher<CGFloat, Never>
    @State private var scrolling: Bool = false
    
    init() {
        self.init(onScrollingStarted: {}, onScrollingFinished: {})
    }
    
    private init(
        onScrollingStarted: @escaping () -> Void,
        onScrollingFinished: @escaping () -> Void
    ) {
        self.onScrollingStarted = onScrollingStarted
        self.onScrollingFinished = onScrollingFinished
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    var body: some View {
        GeometryReader { g in
            Rectangle()
                .onChange(of: g.frame(in: .global).origin) { offset in
                    if !scrolling {
                        scrolling = true
                        onScrollingStarted()
                    }
                    detector.send(offset.x)
                }
                .onReceive(publisher) { _ in
                    scrolling = false
                    onScrollingFinished()
                }
        }
        .foregroundColor(Color.clear)
    }
    
    func onScrollingStarted(_ closure: @escaping () -> Void) -> Self {
        .init(
            onScrollingStarted: closure,
            onScrollingFinished: onScrollingFinished
        )
    }
    
    func onScrollingFinished(_ closure: @escaping () -> Void) -> Self {
        .init(
            onScrollingStarted: onScrollingStarted,
            onScrollingFinished: closure
        )
    }
}
