//
//  BingProvider.swift
//  Picture of the Day
//
//  Created by Vitaly Dyachkov on 8/4/18.
//  Copyright © 2018 Vitaly Dyachkov. All rights reserved.
//

import Cocoa

struct BingImage: Decodable {
    let url: String
}

struct BingImageArchive: Decodable {
    let images: [BingImage]
}

class BingProvider: NSObject {

    let metadataURL = URL(string: "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")!
    let session = URLSession.shared

    func update(with completionHandler: @escaping (URL) -> Void) {

        self.session.dataTask(with: metadataURL) { (data, response, error) in
            guard
                let data = data,
                let imageArchive = try? JSONDecoder().decode(BingImageArchive.self, from: data),
                imageArchive.images.count > 0 else {
                    return
            }

            let image = imageArchive.images[0]
            let remoteImageURL = URL(string: "https://bing.com/" + image.url)!

            self.session.downloadTask(with: remoteImageURL) { (temporaryURL, response, error) in
                guard let temporaryURL = temporaryURL else {
                    return
                }

                let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let localImageURL = URL(string: remoteImageURL.lastPathComponent, relativeTo: documentDirectoryURL)!

                do {
                    try _ = FileManager.default.replaceItemAt(localImageURL, withItemAt: temporaryURL)
                } catch {
                    return
                }

                completionHandler(localImageURL)

                }.resume()

            }.resume()
    }
}
