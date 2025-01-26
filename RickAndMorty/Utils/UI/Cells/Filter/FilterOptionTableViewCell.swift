//
//  FilterOptionTableViewCell.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import UIKit

class FilterOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelName.font = UIFont.custom(type: .regular, size: 14)
        labelValue.font = UIFont.custom(type: .regular, size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
