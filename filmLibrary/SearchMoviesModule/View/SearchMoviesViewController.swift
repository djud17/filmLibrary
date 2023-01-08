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
}

final class SearchMoviesViewController: UIViewController {
    // MARK: - UI Elements
    
    private lazy var searchRequestLabel: UILabel = {
        let label = CustomLabel(withType: .title)
        label.textColor = Constants.Color.white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: Constants.FontSize.large)
        label.text = "Введите ваш запрос"
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = Constants.Color.white
        searchBar.keyboardAppearance = .light
        searchBar.returnKeyType = .search
        
        return searchBar
    }()
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        
        return tableView
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
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.orange
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(nibModels: [MovieTableViewCellModel.self])
        
        searchBar.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupHierarchy() {
        view.addSubview(searchRequestLabel)
        view.addSubview(searchBar)
        view.addSubview(moviesTableView)
    }
    
    private func setupLayout() {
        let smallOffset = Constants.Offset.small
        let mediumOffset = Constants.Offset.medium
        
        searchRequestLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    }
}

extension SearchMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = presenter.getData(by: indexPath.row) else { return UITableViewCell() }
        
        let imageUrl = model.poster?.previewUrl ?? ""
        let movieName = model.name
        let movieInfo = (model.shortDescription ?? model.description) ?? ""
        let movie: CellViewAnyModel = MovieTableViewCellModel(imageUrl: imageUrl, movieName: movieName, movieInfo: movieInfo)
        
        return tableView.dequeueReusableCell(withModel: movie, for: indexPath)
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
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
        moviesTableView.reloadData()
        
        if presenter.getNumberOfRecords() == 0 {
            showNoDataMessage()
        }
    }
    
    private func showNoDataMessage() {
        guard let searchText = searchBar.text else { return }
        
        let message = "По вашему запросу \(searchText) - ничего не найдено. Попробуйте ввести другой запрос."
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
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
