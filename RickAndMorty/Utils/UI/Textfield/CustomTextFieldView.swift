//
//  CustomTextFieldView.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import UIKit

class CustomTextFieldView: UIView {

    private let xibName = "CustomTextFieldView"
    
    @IBOutlet weak var constrainRightTextfield: NSLayoutConstraint!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var viewContainerTextfield: UIView!
    @IBOutlet var contentView: UIView!

    var isIconRight: Bool = false {
        didSet {
            constrainRightTextfield.constant = isIconRight ? 50 : 23
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        _ = NSLayoutConstraint.pinningEdges(view: contentView, toView: self)
        
        viewContainerTextfield.layer.borderWidth = 1.0
        viewContainerTextfield.layer.borderColor = UIColor.gray.cgColor
        viewContainerTextfield.layer.cornerRadius = 26
        
        self.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        contentView.prepareForInterfaceBuilder()
    }
}

