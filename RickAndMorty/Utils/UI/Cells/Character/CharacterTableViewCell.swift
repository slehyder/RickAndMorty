//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var labelLocationDescription: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelStatusAndSpecie: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    func setup(character: Character) {
        labelName.text = character.name
        switch character.status {
        case .alive:
            labelStatus.textColor = .green
        case .dead:
            labelStatus.textColor = .red
        case .unknown:
            labelStatus.textColor = .gray
        case .none:
            labelStatus.textColor = .gray
        }
        labelStatusAndSpecie.text = "\(character.status?.rawValue ?? "Unknown") - \(character.species)"
        labelLocation.text = character.location.name ?? "Unknown"
        
        if let url = URL(string: character.image) {
            imagePhoto.kf.setImage(with: url,options: [
                .processor(DownsamplingImageProcessor(size: imagePhoto.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelName.font = .custom(type: .bold, size: 16)
        labelLocation.font = .custom(type: .regular, size: 13)
        labelStatusAndSpecie.font = .custom(type: .regular, size: 13)
        labelLocationDescription.font = .custom(type: .regular, size: 13)
        viewContent.layer.cornerRadius = 8
        viewContent.layer.shadowColor = UIColor.black.cgColor
        viewContent.layer.shadowOpacity = 0.25
        viewContent.layer.shadowOffset = CGSize(width: 0, height: 4)
        viewContent.layer.shadowRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePhoto.image = nil
    }
}
