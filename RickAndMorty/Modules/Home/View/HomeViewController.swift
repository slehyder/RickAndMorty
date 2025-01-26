//
//  HomeViewController.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    weak var coordinator: AppCoordinator?
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeViewModel = HomeViewModel(apiService: ApiService())
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    @IBAction func buttonFilterAction(_ sender: UIButton) {

        guard let coordinator = coordinator else {
            return
        }
        coordinator.showFilterViewController(from: self,filters: viewModel.filters, sender: buttonFilter, onApplyFilter: { [weak self] itemFiltered in
            
            guard let strongSelf = self else {
                return
            }
            if let itemFiltered = itemFiltered {
                strongSelf.viewModel.filters = itemFiltered
            }
            strongSelf.viewModel.loadCharacters(reset: true) 
        })
    }
    
    func getCharacters() {
        viewModel.loadCharacters()
    }
    
    @objc private func pullToRefresh() {
        viewModel.loadCharacters(reset: true)
    }
}

extension HomeViewController {
    func prepareView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: CharacterTableViewCell.self)
        setupObservers()
        getCharacters()
        buttonFilter.titleLabel?.font = .custom(type: .bold, size: 16)
        tableView.refreshControl = refreshControl
    }
}

// MARK: - Observables

extension HomeViewController {
    
    func setupObservers() {
        viewModel.$characters
            .receive(on: RunLoop.main)
            .sink { [weak self] posts in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
                strongSelf.tableView.refreshControl?.endRefreshing()
                ErrorOverlay.hideErrorOverlay(from: strongSelf.view)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] error in
                guard let strongSelf = self else {
                    return
                }
                if let error = error,
                    !error.isBlank() {
                    Toast(
                        text: error,
                        container: nil,
                        viewController: strongSelf,
                        direction: .bottom,
                        shouldAddExtraBottomMargin: true
                    )
                }
                strongSelf.viewModel.errorMessage = nil
                ErrorOverlay.showErrorOverlay(in: strongSelf.view)
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

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: CharacterTableViewCell.self, for: indexPath)
        cell.setup(character: viewModel.characters[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if position > (contentHeight - frameHeight - 100) {
            viewModel.loadCharacters(reset: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showCharacterDetail(id: viewModel.characters[indexPath.row].id)
    }
}

