//
//  StateCoordinator.swift
//  Prynote3
//
//  Created by tongyi on 12/13/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

protocol StateCoordinatorDelegate: class {
    func didSelectedNote(_ note: Note?)
}

extension StateCoordinatorDelegate {
    func didSelectedNote(_ note: Note?) {}
}

class StateCoordinator {
    var selectedNote: Note? {
        didSet {
            delegate?.didSelectedNote(selectedNote)
        }
    }
    weak var delegate: StateCoordinatorDelegate?
}
