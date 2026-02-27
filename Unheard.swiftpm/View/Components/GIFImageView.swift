//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/27/26.
//

import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        if let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let data = try? Data(contentsOf: url),
           let source = CGImageSourceCreateWithData(data as CFData, nil) {
            
            let frameCount = CGImageSourceGetCount(source)
            var images: [UIImage] = []
            var totalDuration: Double = 0
            
            for i in 0..<frameCount {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: cgImage))
                    
                    if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                       let gifDict = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                       let delay = gifDict[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double ?? gifDict[kCGImagePropertyGIFDelayTime as String] as? Double {
                        totalDuration += delay
                    } else {
                        totalDuration += 0.1
                    }
                }
            }
            
            imageView.animationImages = images
            imageView.animationDuration = totalDuration
            imageView.animationRepeatCount = 1  // ✅ 1회 재생 (0이면 무한 루프)
            imageView.startAnimating()
        }
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
}
