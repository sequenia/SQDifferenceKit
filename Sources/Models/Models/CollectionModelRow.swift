//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import Foundation
import DifferenceKit

public class CollectionModelRow: ModelRow {

    public var sections = [Section]()

    required convenience public init(id: String,
                                     sections: [Section]) {
        self.init(id: id)
        self.sections = sections
    }

    public override func isContentEqual(to source: ModelRow) -> Bool {
        guard let collectionModelRow = source as? CollectionModelRow else { return false }

        return self.differenceIdentifier == source.differenceIdentifier &&
               self.isSectionsContentEqual(to: collectionModelRow.sections)
    }

    public func isSectionsContentEqual(to sourceSections: [Section]) -> Bool {
        var isEqual = true

        for (index, section) in self.sections.enumerated() {
            let sourceSection = sourceSections[index]

            isEqual = isEqual && (section.elements == sourceSection.elements)
        }
        return isEqual
    }
}
