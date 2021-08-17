//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 16.08.2021.
//

import Foundation
import DifferenceKit

open class InfiniteCollectionModelRow: CollectionModelRow {

    public private(set) var originalCount: Int = .zero

    required public convenience init(
        id: String,
        collectionSection: ModelSection,
        collectionRows: [ModelRow],
        showSkeleton: Bool = false,
        showSeparator: Bool = true
    ) {
        self.init(id: id, showSkeleton: showSkeleton, showSeparator: showSeparator)

        self.originalCount = collectionRows.count
        let modelRowCopies = collectionRows.enumerated().map { $1.copyWithPrefix(prefix: "\($0)") }

        var resultRows = modelRowCopies

        if resultRows.count > 1 {
            for _ in 0...(.infiniteCollectionDuplicates - 1) {
                resultRows.append(contentsOf: modelRowCopies)
                resultRows.insert(contentsOf: modelRowCopies, at: 0)
            }
        }
        self.sections = [Section(model: collectionSection, elements: resultRows)]
    }

    override open func isContentEqual(to source: ModelRow) -> Bool {
        guard let collectionModelRow = source as? InfiniteCollectionModelRow else { return false }

        return super.isContentEqual(to: collectionModelRow)
    }

    override open func copy() -> ModelRow {
        let copy = type(of: self).init(
            id: self.differenceIdentifier,
            sections: self.sections,
            showSkeleton: self.showSkeleton,
            showSeparator: self.showSeparator
        )
        copy.originalCount = self.originalCount
        return copy
    }
}

public extension Int {

    static var infiniteCollectionDuplicates = 100
}

