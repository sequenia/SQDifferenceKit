//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import Foundation
import DifferenceKit

open class CollectionModelRow: ModelRow {

    public var sections = [Section]()

    required public convenience init(
        id: String,
        sections: [Section],
        showSkeleton: Bool = false,
        showSeparator: Bool = true
    ) {
        self.init(id: id, showSkeleton: showSkeleton, showSeparator: showSeparator)
        
        self.sections = sections
    }

    open override func isContentEqual(to source: ModelRow) -> Bool {
        guard let collectionModelRow = source as? CollectionModelRow else { return false }

        return super.isContentEqual(to: source) &&
            self.isSectionsContentEqual(to: collectionModelRow.sections)
    }

    open func isSectionsContentEqual(to sourceSections: [Section]) -> Bool {
        if sourceSections.count != self.sections.count { return false }

        var isEqual = true
        for (index, section) in self.sections.enumerated() {
            let sourceSection = sourceSections[index]

            isEqual = isEqual && (section.elements == sourceSection.elements)
        }
        return isEqual
    }

    open override func copy() -> ModelRow {
        return type(of: self).init(
            id: self.differenceIdentifier,
            sections: self.sections,
            showSkeleton: self.showSkeleton,
            showSeparator: self.showSeparator
        )
    }
}
