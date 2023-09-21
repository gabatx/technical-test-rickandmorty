//
//  ImageView.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import SwiftUI
import Kingfisher

struct ImageView: View {

    var urlImage: String?
    var placerholderImage: String = "placeholder"

    var body: some View {
        GeometryReader { geo in
            if let urlImage = urlImage, let image = URL(string: urlImage){
                KFImage.url(image)
                    .renderingMode(.original)
                    .resizable()
                    .placeholder{
                        Image(placerholderImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                    .clipped() // Corta la vista con el tamaño dado
            } else {
                Image(placerholderImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                    .clipped()
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ImageView(urlImage: "https://rickandmortyapi.com/api/character/avatar/8.jpeg")
        }
        .frame(width: 100, height: 100)
    }
}
