//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import UIKit
import DifferenceKit

// MARK: - Associated keys
private struct DiffTableAssociatedKeys {

    static var cellHeights: UInt8 = 0
}

// MARK: - Protocol
public protocol DiffTableProtocol: DiffListProtocol {

    var tableView: UITableView! { get }

    func reloadAnimated()
    func reloadAnimated(_ animated: UITableView.RowAnimation)

    func storeHeight(forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    func height(forCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

// MARK: - Variables
public extension DiffTableProtocol {

    private var cellHeights: [String: CGFloat] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffTableAssociatedKeys.cellHeights) as? [String: CGFloat] else { return [:] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffTableAssociatedKeys.cellHeights, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


// MARK: - Reloads
public extension DiffTableProtocol {

    func reloadAnimated() {
        self.reloadAnimated(.automatic)
    }

    func reloadAnimated(_ animated: UITableView.RowAnimation = .automatic) {
        self.dataInput.sort { $0.model.position.position() < $1.model.position.position() }
        let changeset = StagedChangeset(source: self.data, target: self.dataInput)

        if animated == .none {
            UIView.performWithoutAnimation {
                self.reload(usingChangeset: changeset, animation: animated)
            }
            return
        }
        self.reload(usingChangeset: changeset, animation: animated)
    }

    func reload(usingChangeset changeset: StagedChangeset<[Section]>,
                        animation: UITableView.RowAnimation) {
        self.tableView.reload(using: changeset, with: animation, setData: { (data) in
            self.data = data.map { (section) -> Section in
                let tempsection = section.model.copy()
                let elemets = section.elements.map { $0.copy() }
                return Section(model: tempsection, elements: elemets)
            }
        })
        self.dataInput.removeAll()
    }
}

// MARK: - Cell heights
public extension DiffTableProtocol {

    func storeHeight(forCell cell: UITableViewCell,
                     atIndexPath indexPath: IndexPath) {
        let model = self.data[indexPath.section].elements[indexPath.row]
        self.cellHeights[self.cacheKey(forModel: model, inSection: indexPath.section)] = cell.frame.height
    }

    func height(forCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let model = self.data[indexPath.section].elements[indexPath.row]
        return self.cellHeights[self.cacheKey(forModel: model, inSection: indexPath.section)] ?? 44
    }
}
