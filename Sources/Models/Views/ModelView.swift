//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import Foundation

open class ModelView {

    public private(set) var differenceIdentifier: String!
    public var showSkeleton = false

    required public init(id: String) {
        self.differenceIdentifier = id
    }

    open func isContentEqual(to source: ModelView) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier &&
            self.showSkeleton == source.showSkeleton
    }

    open func copy() -> ModelView {
        let copy =  type(of: self).init(
            id: self.differenceIdentifier
        )
        copy.showSkeleton = self.showSkeleton
        return copy
    }
}

extension ModelView: Equatable {

    public static func == (lhs: ModelView, rhs: ModelView) -> Bool {
        lhs.isContentEqual(to: rhs)
    }

}
