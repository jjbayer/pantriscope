//
//  SearchField.swift
//  pantry
//
//  Created by Joris on 03.11.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct SearchField: View {

    @Binding var searchString: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchString)
                .onChange(of: searchString, perform: { value in
                    if searchString.isEmpty {
                        hideKeyboard()
                    }
                })
                .keyboardType(.alphabet)
            if !searchString.isEmpty {
                Button(action: {
                    searchString = ""
                    hideKeyboard()
                }) {
                    Image(systemName: "delete.left")
                        .foregroundColor(.secondary)
                }
                .padding(5)
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchField_Previews: PreviewProvider {

    struct Preview: View {
        @State private var searchString = ""
        var body: some View {
            SearchField(searchString: $searchString)
        }
    }

    static var previews: some View {
        Preview()
    }
}
