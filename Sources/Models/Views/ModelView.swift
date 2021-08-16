//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import Foundation

open class ModelView {

    public private(set) var differenceIdentifier: String!
    public private(set) var showSkeleton = false

    required public init(
        id: String,
        showSkeleton: Bool = false
    ) {
        self.differenceIdentifier = id
        self.showSkeleton = showSkeleton
    }

    open func isContentEqual(to source: ModelView) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier &&
            self.showSkeleton == source.showSkeleton
    }

    open func copy() -> ModelView {
        return type(of: self).init(
            id: self.differenceIdentifier,
            showSkeleton: self.showSkeleton
        )
    }
}

extension ModelView: Equatable {

    public static func == (lhs: ModelView, rhs: ModelView) -> Bool {
        lhs.isContentEqual(to: rhs)
    }

}
