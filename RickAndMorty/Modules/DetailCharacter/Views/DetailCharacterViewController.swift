//
//  DetailCharacterViewController.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import UIKit
import Combine
import Kingfisher

class DetailCharacterViewController: UIViewController {
    @IBOutlet weak var stackViewContentContainer: UIStackView!
    @IBOutlet weak var labelOriginDescription: UILabel!
    @IBOutlet weak var labelLocationDescription: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelStatusAndSpecie: UILabel!
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelOrigin: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    weak var coordinator: AppCoordinator?
    var idCharacter: Int?
    var viewModel: DetailCharacterViewModel = DetailCharacterViewModel(apiService: ApiService())
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        setupObservers()
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        coordinator?.navigationController.popViewController(animated: true)
    }
}

// MARK: - Observables

extension DetailCharacterViewController {
    
    func setupObservers() {
        viewModel.$character
            .receive(on: RunLoop.main)
            .sink { [weak self] character in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateDataCharacter()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self,
                let error = error,
                !error.isBlank() else { return }
                
                Toast(
                    text: error,
                    container: nil,
                    viewController: self,
                    direction: .bottom,
                    shouldAddExtraBottomMargin: true
                )
                ErrorOverlay.showErrorOverlay(in: self.view)
                self.viewModel.errorMessage = nil
            }
            .store(in: &cancellables)

        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let strongSelf = self else {
                    return
                }
                if isLoading {
                    Loader.showLoader(in: strongSelf.view)
                }else{
                    Loader.hideLoader(from: strongSelf.view)
                }
            }
            .store(in: &cancellables)
    }
}

extension DetailCharacterViewController {
    func prepareView() {
        if let idCharacter = idCharacter {
            viewModel.loadCharacter(id: idCharacter)
        }
        labelName.font = .custom(type: .bold, size: 20)
        labelStatusAndSpecie.font = .custom(type: .bold, size: 15)
        labelLocation.font = .custom(type: .bold, size: 15)
        labelOrigin.font = .custom(type: .bold, size: 15)
        labelOriginDescription.font = .custom(type: .bold, size: 15)
        labelLocationDescription.font = .custom(type: .bold, size: 15)
        buttonBack.layer.shadowColor = UIColor.black.cgColor
        buttonBack.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonBack.layer.shadowRadius = 4
        buttonBack.layer.shadowOpacity = 0.3
        buttonBack.clipsToBounds = false
        buttonBack.backgroundColor = UIColor.white
        buttonBack.layer.cornerRadius = 8
        
    }
    
    func updateDataCharacter() {
        guard let character = viewModel.character else {
            return
        }
        ErrorOverlay.hideErrorOverlay(from: self.view)
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
        labelOrigin.text = character.origin.name ?? "Unknown"
        if let url = URL(string: character.image) {
            imagePhoto.kf.setImage(with: url,options: [
                .processor(DownsamplingImageProcessor(size: imagePhoto.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        }
        stackViewContentContainer.isHidden = false
    }
}
