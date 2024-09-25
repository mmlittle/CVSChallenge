//
//  ContentView.swift
//  CVSChallenge
//
//  Created by Mike Little on 9/24/24.
//

import SwiftUI

struct FlickerCollectionView: View {
    @State var searchText = ""
    @ObservedObject var flickrViewModel = FlickrViewModel()
    
    let config = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: config, spacing: 10) {
                    ForEach(flickrViewModel.thumbnailData, id: \.self) { item in
                        NavigationLink(destination: ImageDetailView(thumbnailData: item)) {
                            Image(uiImage: item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Image Gallery"))
        .searchable(text: $searchText)
        .onAppear() {
            searchText = "cats"
        }
        .onChange(of: searchText) { newValue, oldValue in
            flickrViewModel.search(matching: searchText)
        }
    }
}

struct ImageDetailView: View {
    let thumbnailData: ThumbnailData
    
    var body: some View {
        Image(uiImage: thumbnailData.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
        Text(thumbnailData.title)
        Text(thumbnailData.author)
        Text(thumbnailData.published)
        HTMLText(html: thumbnailData.description)
    }
}

struct HTMLText: UIViewRepresentable {
   let html: String
   func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        DispatchQueue.main.async {
            let data = Data(self.html.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                label.attributedText = attributedString
            }
        }
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {}
}

#Preview {
    FlickerCollectionView()
}
