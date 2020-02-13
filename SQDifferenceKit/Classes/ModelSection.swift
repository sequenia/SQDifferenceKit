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
    public var differenceIdentifier: String = UUID().uuidString
    
    public var position: PositionSection!
    
    public var header: ModelHeader?
    public var footer: ModelFooter?
     
    public init(position: PositionSection) {
        self.position = position
        self.differenceIdentifier = String(position.position())
    }
    
    open func isContentEqual(to source: ModelSection) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier && self.header?.isContentEqual(to: source.header) ?? true && self.footer?.isContentEqual(to: source.footer) ?? true
    }
    
    open func copy() -> ModelSection {
        let object = ModelSection(position: position)
        object.header = self.header?.copy()
        object.footer = self.footer?.copy()
        return object
    }
    
}
