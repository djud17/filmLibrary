//
//  WatchListViewController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit
import SnapKit

protocol WatchListDelegate: AnyObject {
    func showErrorAlert(alertController: UIAlertController)
    func updateView()
}

final class WatchListViewController: UIViewController {
    
    // MARK: - Parameters
    
    private var presenter: WatchListPresenterProtocol
    
    // MARK: - UI Elements
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = MovieSearchBar(with: "Введите название фильма")
        
        return searchBar
    }()
    
    private lazy var filterButton: UIButton = {
        let button = FilterButton(with: "Фильтры")
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - Inits
    
    init(presenter: WatchListPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.loadData()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.orange
        
        navigationItem.title = "Хочу посмотреть"
        navigationItem.titleView?.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(nibModels: [MovieTableViewCellModel.self])
        
        searchBar.delegate = self
        
        hideKeyboardWhenTappedAround()
        navigationController?.hideKeyboardWhenTappedAround()
    }
    
    private func setupHierarchy() {
        view.addSubview(filterButton)
        view.addSubview(searchBar)
        view.addSubview(moviesTableView)
    }
    
    private func setupLayout() {
        let smallOffset = Constants.Offset.small
        let mediumOffset = Constants.Offset.medium
        
        filterButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(smallOffset)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(filterButton.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        moviesTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped() {
        presenter.filterButtonPressed(sender: self)
    }
}

extension WatchListViewController: WatchListDelegate {
    func showErrorAlert(alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func updateView() {
        moviesTableView.reloadData()
    }
}

extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = presenter.getData(by: indexPath.row) else { return UITableViewCell() }
        
        let imageUrl = model.poster?.previewUrl ?? ""
        let movieNameRating = model.name + " - \(model.rating.kinopoisk)"
        let movieInfo = (model.shortDescription ?? model.description) ?? ""
        let movie: CellViewAnyModel = MovieTableViewCellModel(imageUrl: imageUrl, movieName: movieNameRating, movieInfo: movieInfo)
        
        return tableView.dequeueReusableCell(withModel: movie, for: indexPath)
    }
}

extension WatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.itemPressed(sender: self, for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movieId = indexPath.row
            presenter.deleteObject(by: movieId)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension WatchListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchTextChange(searchText: searchText)
    }
}
