//
//  NotesGroup.swift
//  Prynote3
//
//  Created by tongyi on 12/13/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

class NotesGroup {
    var notes: [Note]
    let title: String
    let type: GroupType
    
    init(type: GroupType, notebooks: [Notebook]) {
        self.type = type
        switch type {
        case .single:
            guard notebooks.count == 1 else { fatalError("Single group type must contains 1 notebook") }
            self.notes = notebooks[0].notes
            self.title = notebooks[0].title
        case .all:
            self.notes = notebooks.flatMap { $0.notes }
            self.title = "All Notes"
        case .sharedWithMe:
            self.title = "Shared With Me"
            self.notes = []
        }
    }
    
    enum GroupType {
        case single
        case all
        case sharedWithMe
    }
}
