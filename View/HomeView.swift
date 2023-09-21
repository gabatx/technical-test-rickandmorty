//
//  HomeView.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import SwiftUI
import Factory

struct HomeView: View {

    @ObservedObject var viewModel = Container.shared.homeViewModel()
    @State var show = false
    @State var selection: Int? = nil

    var body: some View {
        GeometryReader {  geo in
            NavigationView {
                List {
                    // Si no encuentra ningún resultado
                    if viewModel.characters.isEmpty && viewModel.isFilteredList {
                        VStack(spacing: 10){

                            Image("placeholder")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(20)
                                .padding(.top, 60)

                            Text("Item Not Found")
                                .font(.body)
                                .bold()

                            Text("Try another character's name. Good luck.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal,30)
                        }
                        .padding()
                    } else {
                        ForEach(viewModel.characters, id: \.id) { character in
                            Button {
                                self.hideKeyboard()
                                selection = character.id
                            } label: {
                                NavigationLink(tag: character.id, selection: $selection) {
                                    CharacterView(idCharacter: character.id)
                                } label: {
                                    CharacterCellView(character: character)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button{
                                    try? viewModel.changeFavoriteState(id: character.id)
                                } label: {
                                    Label("Favorito", systemImage: "star.fill")
                                }
                                .tint(.yellow)
                            }
                        }
                    }

                    // Nueva página añadida al hacer scroll hacia abajo
                    if !viewModel.loadMoreState.isRunning && viewModel.loadMoreState.hasMorePages {
                        Text("")
                            .opacity(0)
                            .onAppear() {
                                Task {
                                    if !viewModel.isFilteredList {
                                        await viewModel.loadNextPage()
                                    }
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .navigationBarTitle(self.show ? "" : "List of characters", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: self.show ? .principal : .navigationBarTrailing) {
                        SearchCharacterToolbar(textField: $viewModel.searchText, show: $show, isFilteredList: $viewModel.isFilteredList, geo: geo)
                    }
                }
            }
            .task {
                await viewModel.loadCharacters()
            }
        }
    }
}

struct CharacterCellView: View {

    var character: CharacterModelViewModel
    var body: some View {
        VStack {
            HStack(spacing: 15){
                ImageView(urlImage: character.image)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 60, height: 60)
                    .overlay(alignment: .topTrailing) {
                        if character.isFavorited {
                            HStack{
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .offset(x:10, y: -8)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                VStack{
                    HStack{
                        VStack(alignment: .leading, spacing: 5) {
                            Text(character.name)
                                .font(.title2)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.secondary)
                            Text(character.species)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer(minLength: 10)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.shared.homeViewModel.register {
            MockHomeViewModel()
        }
        HomeView()
    }
}
#endif


