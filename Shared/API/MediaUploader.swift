//
//  ImageUploader.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/7.
//

import Foundation

import Firebase
import AVFoundation
import SwiftUI



struct MediaUploader {
    
    @AppStorage(CurrentUserDefaults.userID) var userID:String?
    
    
    static func uploadImages(images: [UIImage], type: UploadType, handler: @escaping (_ imageURLs: [String]) -> ()) {
        var imageURLs = [String]()
        let group = DispatchGroup()
        for image in images {
            group.enter()
            uploadImage(image: image, type: type){imageURL in
                imageURLs.append(imageURL)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("Finished upload all images")
            handler(imageURLs)
        }
    }
    
    static func uploadImage(image: UIImage, type: UploadType, handler: @escaping (_ imageURL: String) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            
            print("cannot compress the image")
            return }
        let ref = type.filePath
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            
            print("Successfully uploaded image...")
            
            ref.downloadURL { url, _ in
                guard let imageUrl = url?.absoluteString else {
                    
                    print("failed to upload one image")
                    return
                    
                }
                handler(imageUrl)
            }
        }
    }
    
    
    static func uploadVideo(video: NSData, type: UploadType, handler: @escaping (_ videoURL: String) -> ()) {
        guard let videoData = try? video.compressed(using: .zlib) else { return }
        
        let ref = type.filePath
        
        ref.putData(videoData as Data, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload video \(error.localizedDescription)")
                return
            }
            
            print("Successfully uploaded image...")
            
            ref.downloadURL { url, _ in
                guard let videoUrl = url?.absoluteString else { return }
                handler(videoUrl)
            }
        }
    }
    
}
