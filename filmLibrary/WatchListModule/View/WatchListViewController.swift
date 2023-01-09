//
//  WatchListViewController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit
import SnapKit

protocol WatchListDelegate: AnyObject {
    
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
    }
    
    private func setupHierarchy() {
        view.addSubview(searchBar)
    }
    
    private func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped() {
        
    }
}

extension WatchListViewController: WatchListDelegate {
    
}

extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension WatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
