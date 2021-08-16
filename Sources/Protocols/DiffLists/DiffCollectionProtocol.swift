//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import UIKit
import DifferenceKit

// MARK: - Protocol
public protocol DiffCollectionProtocol: DiffListProtocol {

    var collectionView: UICollectionView! { get }

    func reloadAnimated()
    func reloadAnimated(_ animated: Bool)
}

// MARK: - Reloads
public extension DiffCollectionProtocol {

    func reloadAnimated() {
        self.reloadAnimated(true)
    }

    func reloadAnimated(_ animated: Bool) {
        self.dataInput.sort { $0.model.position.position() < $1.model.position.position() }
        let changeset = StagedChangeset(source: self.data, target: self.dataInput)

        if !animated {
            UIView.performWithoutAnimation {
                self.reload(usingChangeset: changeset)
            }
            return
        }

        self.reload(usingChangeset: changeset)
    }

    func reload(usingChangeset changeset: StagedChangeset<[Section]>) {
        self.collectionView.reload(using: changeset, setData: { (data) in
            self.data = data.map { (section) -> Section in
                let tempsection = section.model.copy()
                let elemets = section.elements.map { $0.copy() }
                return Section(model: tempsection, elements: elemets)
            }
        })
        self.dataInput.removeAll()
    }
}
