//
//  FilterOptionsViewController.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import UIKit

class FilterOptionsViewController: UIViewController {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var onSelectFilter: (String, String) -> Void = { _, _ in }
    
    var keys: [String] = ["Status", "Gender"]
    var valuesDict: [String: [String]] = [
        "Status": Constants.Filters.Status.allCases.map { $0.rawValue },
        "Gender": Constants.Filters.Gender.allCases.map { $0.rawValue }
    ]
    
    var selectedFilters: [String: String] = [:]
    var childs: [String] = []
    var typeFilter: FiltersType = .key
    var keySelect: String = String()
    
    enum FiltersType {
        case key
        case child
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func values(forKey key: String) -> [String] {
        return valuesDict[key] ?? []
    }
}

extension FilterOptionsViewController {
    func prepareView() {
        tableView.register(cell: FilterOptionTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        buttonBack.titleLabel?.font = UIFont.custom(type: .bold, size: 14)
    }
}

// MARK: - UITableViewDataSource

extension FilterOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeFilter {
        case .key:
            return keys.count
        case .child:
            return childs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: FilterOptionTableViewCell.self, for: indexPath)
        switch typeFilter {
        case .key:
            cell.labelName.text = keys[indexPath.row]
            cell.imageArrow.isHidden = false
            if let filter = selectedFilters[keys[indexPath.row]],
                !filter.isBlank() {
                cell.labelValue.text = filter
                cell.labelValue.isHidden = false
            } else {
                cell.labelValue.isHidden = true
            }
        case .child:
            let currentChild = childs[indexPath.row]
            cell.labelName.text = currentChild
            cell.imageArrow.isHidden = true
            cell.labelValue.isHidden = true
            if selectedFilters[keySelect] == currentChild {
                cell.backgroundColor = .systemGray5
            } else {
                cell.backgroundColor = .clear
            }
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeFilter {
        case .key:
            let key = keys[indexPath.row]
            let childsPass = values(forKey: key)
            let vc = FilterOptionsViewController()
            vc.typeFilter = .child
            vc.childs = childsPass
            vc.keySelect = key
            vc.selectedFilters = selectedFilters
            vc.onSelectFilter = { [weak self] keyReturn, childReturn in
                guard let strongSelf = self else { return }
                strongSelf.selectedFilters[keyReturn] = childReturn
                strongSelf.onSelectFilter(keyReturn, childReturn)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case .child:
            let child = childs[indexPath.row]
            selectedFilters[keySelect] = child
            self.navigationController?.popToRootViewController(animated: true)
            onSelectFilter(self.keySelect, child)
        }
    }
}
