//
//  SearchCharacterToolbar.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import SwiftUI

struct SearchCharacterToolbar: View {

    @Binding var textField: String
    @Binding var show: Bool
    @Binding var isFilteredList: Bool
    let geo: GeometryProxy

    init(textField: Binding<String>,
         show: Binding<Bool>,
         isFilteredList: Binding<Bool>,
         geo: GeometryProxy) {
        self._textField = textField
        self._show = show
        self._isFilteredList = isFilteredList
        self.geo = geo
    }
    
    var body: some View {
        HStack {
            if self.show {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                TextField("Search character...", text: self.$textField)
                    .autocorrectionDisabled()
                Spacer()
                Button {
                    withAnimation {
                        self.textField = ""
                        self.show.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            } else {
                Button {
                    withAnimation {
                        self.show.toggle()
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .padding(10)
                }
            }
        }
        .frame(maxWidth: self.show ? geo.size.width : 44)
        .padding(.leading, self.show ? 10 : 0)
        .background(self.show ? Color(.systemGray6) : Color.clear)
        .cornerRadius(20)
        .padding(.bottom, 5)
    }
}

struct SearchCharacterToolbar_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            SearchCharacterToolbar(textField: .constant(""), show: .constant(false), isFilteredList: .constant(false), geo: geo)
        }
    }
}
