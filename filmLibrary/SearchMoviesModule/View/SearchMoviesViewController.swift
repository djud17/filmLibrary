//
//  SearchViewController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit
import SnapKit

protocol SearchMoviesDelegate: AnyObject {
    func updateView()
    func startLoading()
    func showErrorAlert(alertController: UIAlertController)
    func scrollTableViewTop()
}

final class SearchMoviesViewController: UIViewController {
    
    // MARK: - UI Elements

    private lazy var searchBar: UISearchBar = {
        let searchBar = MovieSearchBar(with: "Введите название фильма")
        
        return searchBar
    }()
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = Constants.Size.cornerRadius
        
        return tableView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = FilterButton()
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Parameters
    
    private var presenter: SearchMoviesPresenterProtocol
    private var needLoadMoreData = false
    
    // MARK: - Inits
    
    init(presenter: SearchMoviesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.orange
        
        navigationItem.title = "Поиск"
        navigationItem.titleView?.tintColor = Constants.Color.white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(nibModels: [MovieTableViewCellModel.self])
        
        searchBar.delegate = self
        
        hideKeyboardWhenTappedAround()
        navigationController?.hideKeyboardWhenTappedAround()
    }
    
    private func setupHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(moviesTableView)
        view.addSubview(filterButton)
    }
    
    private func setupLayout() {
        let smallOffset = Constants.Offset.small
        let mediumOffset = Constants.Offset.medium
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(mediumOffset)
            make.leading.equalToSuperview()
            make.trailing.equalTo(filterButton.snp.leading).inset(-mediumOffset)
        }
        
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar.snp.centerY)
            make.trailing.equalToSuperview().inset(smallOffset)
            make.width.height.equalTo(Constants.Size.filterButton)
        }
        
        moviesTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(smallOffset)
        }
    }
    
    @objc private func filterButtonTapped() {
        guard let searchText = searchBar.text else { return }
        
        presenter.filterButtonPressed(sender: self, searchText: searchText)
    }
}

extension SearchMoviesViewController: UITableViewDataSource {
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

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.itemPressed(sender: self, for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = presenter.getNumberOfRecords() / 2
        if indexPath.row == index {
            needLoadMoreData = true
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = presenter.getNumberOfRecords() / 2
        if indexPath.row == index && needLoadMoreData {
            presenter.loadMoreData()
            needLoadMoreData = false
        }
    }
}

extension SearchMoviesViewController: SearchMoviesDelegate {
    func updateView() {
        searchBar.isLoading = false
        moviesTableView.reloadData()
        
        if presenter.getNumberOfRecords() == 0 {
            presenter.errorAppeared()
        }
    }
    
    func startLoading() {
        searchBar.isLoading = true
    }
    
    func showErrorAlert(alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func scrollTableViewTop() {
        moviesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        presenter.searchData(withText: searchText)
        searchBar.resignFirstResponder()
    }
}
