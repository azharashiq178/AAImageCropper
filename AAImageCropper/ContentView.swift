//
//  ContentView.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 24/04/2023.
//

import SwiftUI
import UIKit
import Photos

struct ContentView: View {
    @State var allPhotos : [PHAsset] = [PHAsset]()
    @State var images : [Image] = [Image]()
    @State var selectedImage : Image? = nil
    let loader = AAImageLoader()
    var body: some View {
        

        return NavigationView {
            VStack {
                getCropperView()
                    .frame(height: UIScreen.main.bounds.height/2)
                getImagesFromCamera()
            }
            .navigationTitle("Cropper")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black)
        }
        .onAppear() {
            loader.loadPhotos { photos in
                DispatchQueue.main.async {
                    if allPhotos.count == 0 {
                        allPhotos = photos
                        
                        self.selectFeaturedImage(from: 0)
                        
                    }
                    
                }
            } successImage: { photos in
    //            DispatchQueue.main.async {
    //                self.images = photos
    //            }
            }
        }
    }
    
    
    func selectFeaturedImage(from index : Int) {
        
        AAImageLoader.imageFrom(asset: self.allPhotos[index], size: PHImageManagerMaximumSize) { photo in
            selectedImage = photo
        }
        
    }
    @GestureState var press = false
    @State var isDraggingInsideMainView = false
    func getImagesFromCamera() -> some View {
        
        List {
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                ForEach((0..<self.allPhotos.count), id: \.self) { index in
                    if allPhotos.count != 0 {
                        CustomImage.init(imageAsset: self.allPhotos[index], index: index)
                            .onTapGesture {
                                self.selectFeaturedImage(from: index)
                            }
                            .gesture(
                                LongPressGesture()
                                    .sequenced(before: DragGesture())
                                    .updating($press, body: { value, state, transaction in
                                        switch value {
                                        case .first(let isFirstCompleted):
                                            print("First \(isFirstCompleted)")
                                        case .second(let second, let draggedValue):
                                            print("Second \(second)")
                                            print(draggedValue?.location)
                                            if let location = draggedValue?.location {
                                                self.isDraggingInsideMainView = true
                                            }
                                        }
                                    })
                                    .onEnded({ gestureVal in
                                        print(gestureVal)
                                        print("ended")
                                        self.selectFeaturedImage(from: index)
                                    })
                                    
                            )
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { gesture in
//                                        print("Here")
////                                        offset = gesture.translation
//                                    }
//                                    .onEnded { _ in
//                                        print("Here1")
////                                        if abs(offset.width) > 100 {
////                                            // remove the card
////                                        } else {
////                                            offset = .zero
////                                        }
//                                    }
//                            )

                       
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





struct CustomImage : View {
    
    var imageAsset : PHAsset
    var index : Int
    
    @State var image : Image = Image("")
    
    var body: some View {
        
        return self.image
            .resizable()
            .cornerRadius(10)
            .padding([.leading], 10)
            .frame(width: 100, height: 100)
            .onAppear() {
                AAImageLoader.imageFrom(asset: imageAsset, size: CGSize.init(width: 100, height: 100)) { photo in
                        self.image = photo
                    
                }
            }
            
    }
}
