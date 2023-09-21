//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import SwiftUI
import Factory

struct CharacterView: View {

    @StateObject var viewModel: CharacterViewModel = Container.shared.characterViewModel()
    var idCharacter: Int

    init(idCharacter: Int) {
        self.idCharacter = idCharacter
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ImageView(urlImage: viewModel.character?.image)
                    .blur(radius: 3)
                Color.black.opacity(0.7)
                VStack(alignment: .center, spacing: 40.0){
                    VStack(spacing: 4.0){
                        RoundedImageView(urlImage: viewModel.character?.image)
                            .padding(.bottom)
                        VStack(alignment: .center){
                            Text("Rick & Morty")
                                .font(.title)
                            Text(viewModel.character?.name ?? "Unnamed" )
                                .font(.largeTitle)
                                .bold()
                                .multilineTextAlignment(.center)
                        }
                        Group {
                            Text("Gender: \(viewModel.character?.gender ?? "Gender-neutral")")
                                .font(.title3)
                            Text("Species: \(viewModel.character?.species ?? "No species")")
                                .font(.title3)
                            Text("Status: \(viewModel.character?.status ?? "No status")")
                                .font(.title3)
                        }
                        .redacted(reason: viewModel.loadMoreState.isRunning ? .placeholder : [])
                    }
                    VStack{
                        Text("Last known location:")
                            .font(.title3)
                        Text(viewModel.location?.name ?? "No location")
                            .font(.title3)
                            .italic()
                            .lineLimit(1)
                        Text("Residents: \(viewModel.location?.residents.count ?? 0)")
                            .bold()
                            .font(.title3)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.location?.residents ?? [], id: \.self) { urlImage in
                                    let id = Configuration.extractImageId(urlImage: urlImage)
                                    NavigationLink {
                                        CharacterView(idCharacter: id)
                                    } label: {
                                        ImageView(urlImage: Configuration.mapperUrlImage(id: id))
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 40)
                .foregroundColor(.white)

                VStack{
                    Spacer()
                    if viewModel.loadMoreState.isRunning{
                        IndeterminateProgressView()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .ignoresSafeArea(.all)
            .task {
                if !viewModel.loadMoreState.isRunning {
                    await viewModel.loadCharacter(idCharacter: idCharacter)
                    await viewModel.loadLocation()
                }
            }
            .onDisappear(){
                viewModel.character = nil
            }
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(idCharacter: characterMockTest[0].id)
    }
}
