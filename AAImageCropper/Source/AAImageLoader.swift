//
//  AAImageLoader.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 02/05/2023.
//

import Foundation
import Photos
import UIKit
import SwiftUI

typealias Success = (_ photos:[PHAsset])->Void
typealias SuccessImages = (_ photos:[Image])->Void

class AAImageLoader: NSObject {
    
    private var assets = [PHAsset]()
    private var success:Success? = nil
    private var successImages:SuccessImages? = nil
    var images = [Image]()

    
    func loadPhotos(success:Success!, successImage : SuccessImages!){
        checkForPhotosPermission()
        self.success = success
        self.successImages = successImage
        loadAllPhotos()
    }
    
    private func loadAllPhotos() {
        
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects({ (object, index, stop) -> Void in
            self.assets.append(object)
            if self.assets.count == fetchResult.count{ self.success!(self.assets) }
        })
    }
    
//    func convertAllImages() {
//        for i in 0..<assets.count {
//            imageFrom(asset: assets[i], size: PHImageManagerMaximumSize)
//            if i == assets.count - 1 {
//                successImages!(self.images)
//            }
//        }
//
//    }
    
    
//    func imageFrom(asset:PHAsset, size:CGSize){
//
//        let options = PHImageRequestOptions()
//        options.isSynchronous = false
//        options.deliveryMode = .highQualityFormat
//        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (image, attributes) in
//            if let image = image {
//                self.images.append(Image(uiImage: image))
//            }
//        })
//    }
    
    static func imageFrom(asset:PHAsset, size:CGSize, success:@escaping (_ photo:Image)->Void){

        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (image, attributes) in
            success(Image(uiImage: image!))
            
        })
    }
    
    
    
    private func checkForPhotosPermission(){
        
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
//            loadPhotos()
            return
        }
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
//                    DispatchQueue.main.async {
//                        self.loadPhotos()
//                    }
                }
                else {
                    // Access has been denied.
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    
}
