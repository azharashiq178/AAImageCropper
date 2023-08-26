//
//  ContentView.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 24/04/2023.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var allPhotos : [Image] = []
    @State var images : [Image] = [Image]()
    @State var selectedImage : Image? = nil
    @State var highlightedImage : Image? = nil
    @State var isAnimating = false
    let loader = AAImageLoader()
    var body: some View {
        
        
        return NavigationView {
            ZStack {
                VStack {
                    getCropperView()
                        .frame(height: UIScreen.main.bounds.height/2)
                    getImagesFromCamera()
                }
                if let image = highlightedImage {
                    if isAnimating {
                        image
                            .resizable()
                            .cornerRadius(10)
                            .padding([.leading], 10)
                            .frame(width: 100, height: 100)
                            .position(x: draggedLocation.x, y: draggedLocation.y - 100)
                            .wiggling()
                    }
                    else {
                        image
                            .resizable()
                            .cornerRadius(10)
                            .padding([.leading], 10)
                            .frame(width: 100, height: 100)
                            .position(x: draggedLocation.x, y: draggedLocation.y - 100)
                            .onAppear() {
//                                DispatchQueue.main.async {
//                                    self.isAnimating = true
//                                }
                            }
                    }
                }
            }
            .navigationTitle("Cropper")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black)
        }
        .onAppear() {
            loader.loadPhotos { photos in
            } successImage: { photos in
                DispatchQueue.main.async {
                    if allPhotos.count == 0 {
                        allPhotos = photos
                        
                        self.selectFeaturedImage(from: 0)
                        
                    }
                    
                }
            }
        }
    }
    
    
    func selectFeaturedImage(from index : Int) {
        
        selectedImage = self.allPhotos[index]
        
    }
    @GestureState var press = false
    @State var isDraggingInsideMainView = false
    @State var selectedIndex = 0
    @State var draggedLocation: CGPoint = .zero
    func getImagesFromCamera() -> some View {
        
        
        ZStack {
            
            List {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                    ForEach((0..<self.allPhotos.count), id: \.self) { index in
                        if allPhotos.count != 0 {
                            ZStack {
                                self.allPhotos[index]
                                    .resizable()
                                    .overlay(selectedIndex == index ? Color.white.opacity(0.5) : Color.clear)
                                    .cornerRadius(10)
                                    .padding([.leading], 10)
                                    .frame(width: 100, height: 100)
                                
                                    .gesture(
                                        LongPressGesture()
                                            .onEnded({ val in
                                                self.highlightedImage = self.allPhotos[index]
                                            })
                                            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .global))
                                            .updating($press, body: { value, state, transaction in
                                                switch value {
                                                case .first(let isFirstCompleted):
                                                    print("First \(isFirstCompleted)")
                                                    self.draggedLocation = CGPoint.init(x: -100, y: -100)
                                                case .second(let second, let draggedValue):
                                                    print("Second \(second)")
                                                    print(draggedValue?.location)
                                                    if let location = draggedValue?.location {
                                                        self.isDraggingInsideMainView = true
                                                        if self.draggedLocation != location, !isAnimating {
                                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                                                                self.isAnimating = true
                                                            }
                                                        }
                                                        self.draggedLocation = location
                                                    }
                                                }
                                            })
                                            .onEnded({ gestureVal in
                                                print(gestureVal)
                                                self.highlightedImage = nil
                                                self.isAnimating = false
                                                if draggedLocation.y < (UIScreen.main.bounds.height/2) {
                                                    print("ended")
                                                    self.selectFeaturedImage(from: index)
                                                    self.selectedIndex = index
//                                                    draggedLocation = CGPoint(x: -500, y: 300)
                                                }
                                            })
                                    )
                            }
                        }
                        
                    }
                }
                .listRowBackground(Color.black)
                .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
            .listItemTint(.black)
            .background(Color.black)
        }
    }
    func getCropperView() -> some View {
        return GeometryReader { proxy in
            if selectedImage != nil {
                self.selectedImage!
                    .resizable()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .scaledToFit()
                    .clipShape(Rectangle())
                    .modifier(ScrollViewModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background(Color.red)
    }
}
