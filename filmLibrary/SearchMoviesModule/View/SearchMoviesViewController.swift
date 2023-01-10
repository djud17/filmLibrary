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
    
    private lazy var searchRequestLabel: UILabel = {
        let label = CustomLabel(withType: .title)
        label.textColor = Constants.Color.white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: Constants.FontSize.large)
        
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = MovieSearchBar(with: "Введите название фильма")
        
        return searchBar
    }()
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var loadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = Constants.Color.orange
        
        return activityIndicator
    }()
    
    private lazy var filterButton: UIButton = {
        let button = FilterButton(with: "Фильтры")
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
        view.addSubview(searchRequestLabel)
        view.addSubview(searchBar)
        view.addSubview(moviesTableView)
        view.addSubview(loadingActivityIndicator)
        view.addSubview(filterButton)
    }
    
    private func setupLayout() {
        let smallOffset = Constants.Offset.small
        let mediumOffset = Constants.Offset.medium
        
        filterButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(smallOffset)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        searchRequestLabel.snp.makeConstraints { make in
            make.top.equalTo(filterButton.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(searchRequestLabel.snp.bottom).offset(smallOffset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        moviesTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        loadingActivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
        loadingActivityIndicator.stopAnimating()
        moviesTableView.reloadData()
        
        if presenter.getNumberOfRecords() == 0 {
            presenter.errorAppeared()
        }
    }
    
    func startLoading() {
        loadingActivityIndicator.startAnimating()
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
        
        searchRequestLabel.text = "Результаты по запросу: \(searchText)"
        presenter.searchData(withText: searchText)
        searchBar.resignFirstResponder()
    }
}
