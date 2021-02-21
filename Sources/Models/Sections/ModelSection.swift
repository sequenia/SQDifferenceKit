//
//  ModelSection.swift
//  SQDifferenceKit
//
//  Created by Ivan Mikhailovskii on 11/02/2020.
//  Copyright © 2020 Ivan Mikhailovskii. All rights reserved.
//

import Foundation
import DifferenceKit

public typealias Section = ArraySection<ModelSection, ModelRow>

public protocol PositionSection {
    func position() -> Int
}

open class ModelSection: Differentiable {
    
    public typealias DifferenceIdentifier = String
    public private(set) var differenceIdentifier: String
    
    public private(set) var position: PositionSection!
    
    public var header: ModelView?
    public var footer: ModelView?
    
    required public init(id: String, position: PositionSection) {
        self.differenceIdentifier = id
        self.position = position
    }
     
    required public init(position: PositionSection) {
        self.position = position
        self.differenceIdentifier = String(position.position())
    }
    
    open func isContentEqual(to source: ModelSection) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier && self.header?.isContentEqual(to: source.header) ?? true && self.footer?.isContentEqual(to: source.footer) ?? true
    }
    
    open func copy() -> ModelSection {
        let object = type(of: self).init(id: self.differenceIdentifier,
                                         position: self.position)
        object.header = self.header?.copy()
        object.footer = self.footer?.copy()
        return object
    }
    
}
