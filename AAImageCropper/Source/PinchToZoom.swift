//
//  PinchedView.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 02/05/2023.
//

import SwiftUI

struct PinchToZoom: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @State var anchor: UnitPoint = .center
    @Binding var isPinching: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .animation(.spring(), value: isPinching)
            .overlay(PinchZoomOverlay(minScale: minScale, maxScale: maxScale, scale: $scale, isPinching: $isPinching))
    }
}


struct PinchZoomOverlay: UIViewRepresentable {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @Binding var isPinching: Bool
    
    func makeUIView(context: Context) -> PinchedUIView {
        let pinchZoomView = PinchedUIView(minScale: minScale, maxScale: maxScale, currentScale: scale, scaleChange: { scale = $0 }, pinchChange: { value in
            isPinching = value
        })
        return pinchZoomView
    }
    
    func updateUIView(_ pageControl: PinchedUIView, context: Context) { }
}


class PinchedUIView: UIView {
    let minScale: CGFloat
    let maxScale: CGFloat
    var isPinching: Bool = false
    var scale: CGFloat = 1.0
    let scaleChange: (CGFloat) -> Void
    let pinchChange: (Bool) -> Void
    
    init(minScale: CGFloat,
           maxScale: CGFloat,
         currentScale: CGFloat,
         scaleChange: @escaping (CGFloat) -> Void, pinchChange: @escaping (Bool) -> Void) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.scale = currentScale
        self.scaleChange = scaleChange
        self.pinchChange = pinchChange
        super.init(frame: .zero)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            isPinching = true
            pinchChange(isPinching)
            
        case .changed:
            if gesture.scale <= minScale {
                scale = minScale
            } else if gesture.scale >= maxScale {
                scale = maxScale
            } else {
                scale = gesture.scale
            }
            scaleChange(scale)
        case .ended:
            isPinching = false
            pinchChange(isPinching)
            break
        case .cancelled, .failed:
            isPinching = false
            scale = 1.0
            pinchChange(isPinching)
        default:
            break
        }
    }
}
