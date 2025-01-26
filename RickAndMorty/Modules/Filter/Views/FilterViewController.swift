//
//  FilterViewController.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var buttonSearchLens: UIButton!
    @IBOutlet weak var viewContainerFilters: UIView!
    @IBOutlet weak var labelFiltersValue: UILabel!
    @IBOutlet weak var labelFiltersTitle: UILabel!
    
    @IBOutlet weak var buttonFilters: UIButton!
    @IBOutlet weak var buttonClean: UIButton!
    @IBOutlet weak var buttonApplyFilters: UIButton!
    @IBOutlet weak var viewCustomTextfieldSearch: CustomTextFieldView!
    
    var viewModel: FilterListViewModel = FilterListViewModel()
    var onApplyFilter: (CharacterFilters?)->() = {_  in }
    var selectedFilters: CharacterFilters = CharacterFilters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    @IBAction func buttonCleanAction(_ sender: UIButton) {
        viewModel.resetFilters()
        viewCustomTextfieldSearch.textfield.text = nil
        updateFilterLabels()
    }
    
    @IBAction func buttonApplyFiltersAction(_ sender: UIButton) {
        if let text = viewCustomTextfieldSearch.textfield.text, !text.isBlank() {
            viewModel.textToSearch = text
        }
        self.dismiss(animated: true) {
            self.onApplyFilter(self.viewModel.applyFilters())
        }
    }
    
    @IBAction func buttonFiltersAction(_ sender: UIButton) {
        let vc = FilterOptionsViewController()
        vc.keys = ["Status", "Gender"]
        vc.valuesDict = [
            "Status": Constants.Filters.Status.allCases.map { $0.rawValue },
            "Gender": Constants.Filters.Gender.allCases.map { $0.rawValue }
        ]
        
        var selectedFilters = [String: String]()
        if let gender = viewModel.characterFilters.gender {
            selectedFilters["Gender"] = gender.rawValue
        }
        if let status = viewModel.characterFilters.status {
            selectedFilters["Status"] = status.rawValue
        }
        vc.selectedFilters = selectedFilters
        
        vc.onSelectFilter = { [weak self] key, value in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.updateFilter(forKey: key, value: value)
            strongSelf.updateFilterLabels()
        }
        
        vc.preferredContentSize = CGSize(width: 300, height: 216)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FilterViewController {
    func prepareView() {
        viewModel.characterFilters = selectedFilters
        viewContainerFilters.layer.cornerRadius = 16
        viewContainerFilters.layer.shadowColor = UIColor.black.cgColor
        viewContainerFilters.layer.shadowOpacity = 0.25
        viewContainerFilters.layer.shadowOffset = CGSize(width: 0, height: 4)
        viewContainerFilters.layer.shadowRadius = 5
        viewContainerFilters.backgroundColor = UIColor.white
        
        styleButton(buttonClean, textColor: .systemRed, borderColor: .systemRed)
        styleButton(buttonApplyFilters, textColor: .systemGreen, borderColor: .systemGreen)
        
        viewCustomTextfieldSearch.viewContainerTextfield.layer.cornerRadius = 12
        viewCustomTextfieldSearch.viewContainerTextfield.layer.borderWidth = 2
        viewCustomTextfieldSearch.viewContainerTextfield.layer.borderColor = UIColor.systemGreen.cgColor
        viewCustomTextfieldSearch.viewContainerTextfield.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        viewCustomTextfieldSearch.textfield.delegate = self
        viewCustomTextfieldSearch.textfield.font = UIFont.custom(type: .bold, size: 16)
        viewCustomTextfieldSearch.textfield.textColor = .white
        viewCustomTextfieldSearch.textfield.tintColor = .systemGreen
        viewCustomTextfieldSearch.textfield.attributedPlaceholder = NSAttributedString(
            string: "Buscar...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2]
        )
        
        buttonSearchLens.tintColor = UIColor.systemGreen
        viewCustomTextfieldSearch.bringSubviewToFront(buttonSearchLens)
        
        labelFiltersTitle.font = UIFont.custom(type: .bold, size: 14)
        updateFilterLabels()
    }
    
    private func styleButton(_ button: UIButton, textColor: UIColor, borderColor: UIColor) {
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.custom(type: .bold, size: 14)
    }
    
    func updateFilterLabels() {
        if let name =  viewModel.characterFilters.name, !name.isEmpty {
            viewCustomTextfieldSearch.textfield.text = name
        }
        let selectedFilterText = viewModel.getSelectedFiltersText()
        labelFiltersValue.text = selectedFilterText.isEmpty ? nil : selectedFilterText
        labelFiltersValue.textColor = .systemGreen
        labelFiltersValue.font = UIFont.custom(type: .bold, size: 14)
        labelFiltersValue.numberOfLines = 0
    }
}

// MARK: - Textfield Delegates

extension FilterViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9. ]*$", options: [])
        let matches = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        return matches != nil && matches?.range == NSRange(location: 0, length: string.utf16.count)
    }
}
