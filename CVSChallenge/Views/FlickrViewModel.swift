//
//  FlickrViewModel.swift
//  CVSChallenge
//
//  Created by Mike Little on 9/24/24.
//

import Foundation
import os.log
import SwiftUI

class FlickrViewModel: NSObject, ObservableObject {
    @Published var searchText = ""
    @Published var error = ""
    @Published var thumbnailData = [ThumbnailData]()
    
    override init() {
        super.init()
    }
    
    func getthumbnailImage(url: String) async throws -> UIImage? {
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        let image = UIImage(data: data)
        return image
    }
    
    func getthumbnailData(items: [Item]) async throws {
        var image: UIImage?
        
        for item in items {
            print(item.media.m)
            image = try await getthumbnailImage(url: item.media.m)!
            DispatchQueue.main.async {
                let thumbnailData = ThumbnailData(title: item.title,
                                                  description: item.description,
                                                  published: item.published,
                                                  author: item.author,
                                                  image: image!)
                self.thumbnailData.append(thumbnailData)
            }
        }
    }
    
    func getFlickerData(searchString: String) async throws -> FlickrData? {
        let json: FlickrData
        
        let url = APIConstants.flickrDataURL + searchString
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        do {
            json = try JSONDecoder().decode(FlickrData.self, from: data)
            return json
        } catch {
            print ("Error: \(error)")
        }
        return nil
    }
    
    func search(matching: String) {
        thumbnailData.removeAll()
        
        Task {
            var searchResults: FlickrData?
            try await searchResults = getFlickerData(searchString: matching)
            if let results = searchResults {
                try await self.getthumbnailData(items: results.items)
            }
        }
    }
}
