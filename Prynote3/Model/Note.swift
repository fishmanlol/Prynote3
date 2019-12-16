//
//  Note.swift
//  Prynote3
//
//  Created by tongyi on 12/13/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

class Note {
    var id: UUID = UUID()
    var title: String = ""
    var content: String = ""
    var isLoading = false
    var date = Date()
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    static func mock() -> Note {
        return Note(title: "", content: "")
    }
    
    func load(completion: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.title = "Aaaaa"
            self.content = "Bbbbbbbb"
            self.isLoading = false
            completion()
        }
    }
}

extension Note: Equatable {
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
}
