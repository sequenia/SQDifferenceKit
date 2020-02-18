//
//  ViewController.swift
//  SQDifferenceKit
//
//  Created by lab-devoloper on 02/13/2020.
//  Copyright (c) 2020 lab-devoloper. All rights reserved.
//

import UIKit
import SQDifferenceKit
import DifferenceKit

enum MainSreen: Int, PositionSection {
    case testSection
    case testSection2
    case testSection3
    
    func position() -> Int {
        return self.rawValue
    }
    
    var id: String {
        return String(self.rawValue)
    }
    
    func modelSection() -> ModelSection {
        return ModelSection(position: self)
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var data = [Section]()
    var dataInput = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()

    }
    
    func configureTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        self.registerCell()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(self.tapButton))
    }
    
    @objc func tapButton() {
        self.show()
    }
    
    func registerCell() {
        self.tableView.sq_register(TestTableCell.self)
    }
    
    func show() {
        
        if Bool.random() {
            let items = [TestModelRow(id: "1", text: UUID().uuidString),
                         TestModelRow(id: "2", text: "text2"),
                         TestModelRow(id: "3", text: UUID().uuidString)]
        
            self.appendOrReplaceSection(Section(model: MainSreen.testSection.modelSection(), elements: items))
        
        } else if Bool.random() {
            let items = [TestModelRow(id: "1", text: "text1"),
                         TestModelRow(id: "2", text: "text2"),
                         TestModelRow(id: "3", text: UUID().uuidString)]
            
            let modelSection = MainSreen.testSection2.modelSection()
            
            modelSection.header = ModelHeader(id: UUID().uuidString)
            
            self.appendOrReplaceSection(Section(model: modelSection, elements: items))
        }
        else {
            let items = [TestModelRow(id: "1", text: UUID().uuidString),
                         TestModelRow(id: "2", text: "text2"),
                         TestModelRow(id: "3", text: "text3")]

            self.appendOrReplaceSection(Section(model: MainSreen.testSection3.modelSection(), elements: items))
        }
        
        self.reloadAnimated()
    }
    
    func appendOrReplaceSection(_ section: Section) {
        if let index = self.dataInput.firstIndex(where: { $0.differenceIdentifier == section.differenceIdentifier }) {
            self.dataInput[index] = section
            return
        }

        self.dataInput.append(section)
    }
    
    func reloadAnimated() {
        self.dataInput = self.dataInput.sorted(by: { $0.model.position.position() < $1.model.position.position() })
        let changeset = StagedChangeset(source: self.data, target: self.dataInput)
        
        self.tableView.reload(using: changeset, with: .automatic, setData: { (data) in
            self.data = data.map { (section) -> Section in
                let tempsection = section.model.copy()
                let elemets = section.elements.map { $0.copy() }
                return Section(model: tempsection, elements: elemets)
            }
        })
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ =  self.data[section].model.header else { return .zero }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.data[section].model.header?.differenceIdentifier
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.data[indexPath.section].elements[indexPath.row]

        if let data = data as? TestModelRow {
            let cell = self.tableView.sq_dequeueReusableCell(TestTableCell.self, indexPath: indexPath)

            cell?.bind(model: data)
            return cell!
        }
        
        return UITableViewCell()
    }
    
    
}
