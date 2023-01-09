//
//  ViewController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import UIKit
import SnapKit

protocol PopularMoviesDelegate: AnyObject {
    func updateView()
}

final class PopularMoviesViewController: UIViewController {
    private var presenter: PopularMoviesPresenterProtocol
    
    // MARK: - UI elements
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let inset = Constants.Offset.smallCellInset
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(width: Constants.Size.imageWidth, height: Constants.Size.imageHeight)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private lazy var loadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = Constants.Color.white
        
        return activityIndicator
    }()
    
    // MARK: - Inits
    
    init(presenter: PopularMoviesPresenterProtocol) {
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
        getInitialData() 
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.orange
        
        navigationItem.title = "Top-50"
        navigationItem.titleView?.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        moviesCollectionView.register(nibModels: [MovieCollectionViewCellModel.self])
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }
    
    private func setupHierarchy() {
        view.addSubview(moviesCollectionView)
        view.addSubview(loadingActivityIndicator)
    }
    
    private func setupLayout() {        
        moviesCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingActivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func getInitialData() {
        loadingActivityIndicator.startAnimating()
        presenter.loadData()
    }
}

extension PopularMoviesViewController: PopularMoviesDelegate {
    func updateView() {
        loadingActivityIndicator.stopAnimating()
        moviesCollectionView.reloadData()
    }
}

extension PopularMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfRecords()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = presenter.getData(for: indexPath.row) else { return UICollectionViewCell() }
        
        let imageUrl = model.poster?.previewUrl ?? ""
        let movie: CellViewAnyModel = MovieCollectionViewCellModel(imageUrl: imageUrl)
        
        return collectionView.dequeueReusableCell(withModel: movie, for: indexPath)
    }
}

extension PopularMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.itemPressed(for: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
