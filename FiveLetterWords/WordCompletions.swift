//
//  WordCompletions.swift
//  FiveLetterWords
//
//  Created by Jonathan Pryor on 6/30/25.
//

import Foundation
import CoreFoundation

func getResourceNamePath(_ resourceName: String) -> String? {
    let parts = resourceName.split(separator:".")
    let name = String(parts[0])
    let ext = String(parts[1])
    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
        return nil
    }
    return url.path(percentEncoded: false)
}

struct WordCompletions {
    var words : [String.SubSequence]

    init(resourceName: String) {
        guard let resourcePath = getResourceNamePath(resourceName) else {
            print("# jonp: Could not find path for \(resourceName)!")
            words = [String.SubSequence]()
            return
        }
        do {
            print("# jonp: loading path=\(resourcePath)")
            let fileContents = try String(contentsOfFile:resourcePath, encoding:.utf8)
            words = fileContents.split(separator:"\n")
        }
        catch {
            print("# jonp: could not open `\(resourcePath)`: \(error)")
            words = [String.SubSequence]()
        }
    }
}

extension WordCompletions {
    func matches<C : Collection>(template : C)
        -> some Collection<String.SubSequence>
        where C.Element == Character?, C.Index == Int
    {
        var values = [String.SubSequence]();
        for word in words {
            if word.unicodeScalars.count != template.count {
                continue
            }
            var add = true;
            for index in word.unicodeScalars.indices {
                let templateIndex = word.distance(from:word.indices.first!, to:index)
                guard let c = template[templateIndex] else {
                    continue
                }
                if c.lowercased() != word [index].lowercased() {
                    add = false;
                }
            }
            if add {
                values.append(word)
            }
        }
        return values
    }
}
