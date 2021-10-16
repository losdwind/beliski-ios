//
//  ImageUploader.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/7.
//

import Foundation

import UIKit
import Firebase
import AVFoundation

enum UploadType {
    case profile
    case journal
    case task
    case person
    
    var filePath: StorageReference {
        let filename = NSUUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_medias/\(filename)")
        case .journal:
            return Storage.storage().reference(withPath: "/journal_medias/\(filename)")
        case .task:
            return Storage.storage().reference(withPath: "/task_medias/\(filename)")
        case .person:
            return Storage.storage().reference(withPath: "/person_medias/\(filename)")
        }
    }
}

struct MediaUploader {
    
    static func uploadImages(images: [UIImage], type: UploadType, completion: @escaping (_ imageURLs: [String]) -> ()) {
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
            print("Finished all requests.")
            completion(imageURLs)
        }
    }
    
    static func uploadImage(image: UIImage, type: UploadType, completion: @escaping (_ imageURL: String) -> ()) {
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
                completion(imageUrl)
            }
        }
    }
    
    
    static func uploadVideo(video: NSData, type: UploadType, completion: @escaping (_ videoURL: String) -> ()) {
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
                completion(videoUrl)
            }
        }
    }
    
}
