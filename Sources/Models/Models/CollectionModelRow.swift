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

    required convenience public init(id: String,
                                     sections: [Section]) {
        self.init(id: id)
        self.sections = sections
    }

    open override func isContentEqual(to source: ModelRow) -> Bool {
        guard let collectionModelRow = source as? CollectionModelRow else { return false }

        return self.differenceIdentifier == source.differenceIdentifier &&
               self.isSectionsContentEqual(to: collectionModelRow.sections)
    }

    internal func isSectionsContentEqual(to sourceSections: [Section]) -> Bool {
        var isEqual = true

        for (index, section) in self.sections.enumerated() {
            let sourceSection = sourceSections[index]

            isEqual = isEqual && (section.elements == sourceSection.elements)
        }
        return isEqual
    }
}
