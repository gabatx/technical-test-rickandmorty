//
//  RoundedImageView.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import SwiftUI
import Kingfisher

struct RoundedImageView: View {

    var urlImage: String?
    var placerholderImage: String = "placeholder"
    
    var body: some View {
        if let urlImage = urlImage, let image = URL(string: urlImage){
            KFImage.url(image)
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
                .shadow(radius: 5)
        } else {
            Image(placerholderImage)
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
                .shadow(radius: 5)
        }

    }
}

struct RoundedImageView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedImageView(urlImage: characterMockTest[0].image)
    }
}
