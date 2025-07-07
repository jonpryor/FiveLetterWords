//
//  ContentView.swift
//  FiveLetterWords
//
//  Created by Jonathan Pryor on 6/30/25.
//

import SwiftUI

let appDocsMarkdown = """
    Do you ever have problems thinking of words with letters in a given position, such as with
    crossword puzzles?

    Use **—** to shorten the length of words searched.  Use **+** to increase the length of words searched.

    Tap within one of the text boxes underneath **Letters**, enter a letter, then tap **Search**.

    All words with the specified length and letters in the given position are shown underneath **Matches**.

    Word list comes from macOS `/usr/share/dict/words`.
    """

let appDocs = try! AttributedString(
    markdown: appDocsMarkdown,
    options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))

struct CharacterInputView: View {
    @State private var xmatches : [String] = []
    @State private var xtemplate : [String]
    @State private var documentationPopover : DocumentationPopoverModel?
    @FocusState private var showKeyboard : Bool

    init() {
        var t = [String]()
        for cp in template {
            guard let c = cp else {
                t.append("")
                continue
            }
            t.append(String(c))
        }
        xtemplate = t
    }

    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("Find words!")
                    .font(.largeTitle)
                Button {
                    documentationPopover = DocumentationPopoverModel(docs: appDocs)
                } label: {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                }
                .popover(item: $documentationPopover) { detail in
                    Text("Find Five Letter Words")
                        .font(.title)
                    Text("\(detail.docs)")
                        .padding()
                    Button("Dismiss") {
                        documentationPopover = nil
                    }
                }
            }
            Spacer()
            Text("Letters")
                .font(.title)
            HStack {
                Button {
                    removeTemplateCharacter()
                } label: {
                    Image(systemName: "minus")
                        .imageScale(.large)
                }
                ForEach(0..<xtemplate.count, id:\.description) { index in
                    TextField("", text:$xtemplate[index])
                        .jonpSetCommon()
                        .focused($showKeyboard)
                        .limitInputLength(value: $xtemplate[index], length: 1)
                        .onSubmit {
                            _updateMatches(index: index, value: xtemplate[index])
                        }
                }
                Button {
                    addTemplateCharacter()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
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
            if (xmatches.count == 0) {
                Text("No matching words found.")
                    .italic()
                if xtemplate.allSatisfy({ $0.isEmpty }) {
                    Text("Try entering some letters?")
                        .italic()
                }
            }
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

    private func didDismissDocs() {
    }

    private func removeTemplateCharacter() {
        if xtemplate.count == 1 {
            return
        }
        xtemplate.removeLast()
        xtemplate = xtemplate
    }

    private func addTemplateCharacter() {
        xtemplate.append("")
        xtemplate = xtemplate
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

struct DocumentationPopoverModel : Identifiable {
    var id : String { docs.description }
    let docs : AttributedString
}

#Preview {
    CharacterInputView()
}
