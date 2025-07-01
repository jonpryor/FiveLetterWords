//
//  ContentView.swift
//  FiveLetterWords
//
//  Created by Jonathan Pryor on 6/30/25.
//

import SwiftUI

struct CharacterInputView: View {
    @State private var xmatches : [String] = []
    @State private var xtemplate : [String] = ["", "", "", "", ""]
    @FocusState private var showKeyboard : Bool

    init() {
        print("# jonp: xtemplate has \(xtemplate.count) items")
    }

    var body: some View {
        VStack(alignment:.leading) {
            Text("Find five letter words!")
            Text("Letters")
                .font(.title)
            HStack {
                ForEach(0..<xtemplate.count, id:\.description) { index in
                    TextField("", text:$xtemplate[index])
                        .jonpSetCommon()
                        .focused($showKeyboard)
                        .limitInputLength(value: $xtemplate[index], length: 1)
                        .onSubmit {
                            _updateMatches(index: index, value: xtemplate[index])
                        }
                }
            }
            Spacer()
            HStack {
                Button("Clear") {
                    clearSearch()
                }
                Spacer()
                Button("Search") {
                    search()
                }
            }
            Spacer()
            Text("Matches")
                .font(.title)
            List {
                ForEach(0..<xmatches.count, id: \.description) { index in
                    Text(xmatches[index])
                }
            }
        }.padding()
    }

    private func _updateMatches(index: Int, value: String) -> Void {
        xmatches = matches(template:xtemplate)
    }

    private func clearSearch() {
        for index in 0..<xtemplate.count {
            xtemplate[index] = ""
            template[index] = nil
        }
        xmatches = [String]()
    }

    private func search() {
        print("# jonp: search…? xtemplate=\(xtemplate)")
        showKeyboard = false
        xmatches = matches(template: xtemplate)
    }
}

extension TextField {
    func jonpSetCommon() -> some View {
        return self
            .font(.title)
            .fontDesign(.monospaced)
            .buttonBorderShape(.buttonBorder)
            .border(Color.gray)
            .foregroundColor(.accentColor)
            .multilineTextAlignment(.center)
    }
}

// https://sanzaru84.medium.com/swiftui-an-updated-approach-to-limit-the-amount-of-characters-in-a-textfield-view-984c942a156
struct TextFieldLimitModifier : ViewModifier {
    @Binding var value : String
    var length: Int

    func body(content: Content) -> some View {
        content.onChange(of: $value.wrappedValue) {
            value = String($value.wrappedValue.prefix(length))
        }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifier(value: value, length: length))
    }
}

#Preview {
    CharacterInputView()
}
