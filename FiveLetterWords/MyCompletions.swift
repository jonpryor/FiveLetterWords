//
//  MyCompletions.swift
//  FiveLetterWords
//
//  Created by Jonathan Pryor on 6/30/25.
//

import SwiftUI

// let completions = WordCompletions(filePath:"/usr/share/dict/words")
let completions = WordCompletions(resourceName:"words-en.txt")
var template : [Character?] = [
    nil,
    nil,
    nil,
    nil,
    nil,
]

func convertTemplate(_ input: [String]) -> [Character?] {
    var template = [Character?]()
    for s in input {
        template.append(s.isEmpty ? nil : s.first)
    }
    return template
}

func matches(template: [String]) -> [String] {
    let ms = completions.matches(template: convertTemplate(template))

    var newMatches = [String]()
    for m in ms {
        newMatches.append(String(m))
    }

    return newMatches
}


func matches() -> [String] {
    let ms = completions.matches(template: template)

    var newMatches = [String]()
    for m in ms {
        newMatches.append(String(m))
    }

    return newMatches
}

func matchesUpdatingTemplate(index: Int, value: String) -> [String] {
    template[index] = value.isEmpty ? nil : value.first

    return matches()
}
