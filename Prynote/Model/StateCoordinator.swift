//
//  StateCoordinator.swift
//  Prynote3
//
//  Created by tongyi on 12/13/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

protocol StateCoordinatorDelegate: class {
    func didSelectedNote(_ note: Note?, in notebook: Notebook)
}

extension StateCoordinatorDelegate {
    func didSelectedNote(_ note: Note?, in notebook: Notebook) {}
}

class StateCoordinator {
    func select(_ note: Note?, in notebook: Notebook) {
        delegate?.didSelectedNote(note, in: notebook)
    }
    weak var delegate: StateCoordinatorDelegate?
}
