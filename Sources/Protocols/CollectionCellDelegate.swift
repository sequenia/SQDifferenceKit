//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import UIKit

public protocol CollectionCellDelegate: class {

    func saveScrollPosition(_ position: CGPoint,
                            forModel model: CollectionModelRow?)

    func collectionModel(_ model: CollectionModelRow?,
                         willShowModelRow modelRow: ModelRow?,
                         inSection: ModelSection?)

    func collectionModel(_ model: CollectionModelRow?,
                         didSelectModel modelRow: ModelRow?,
                         inSection: ModelSection?)
}
