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
    
    private let moviesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: Constants.Size.imageWidth, height: Constants.Size.imageHeight)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    init(presenter: PopularMoviesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        getInitialData() 
    }
    
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
    }
    
    private func setupLayout() {
        moviesCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func getInitialData() {
        presenter.loadData()
    }
}

extension PopularMoviesViewController: PopularMoviesDelegate {
    func updateView() {
        moviesCollectionView.reloadData()
    }
}

extension PopularMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfRecords()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = presenter.getData(for: indexPath.row) else { return UICollectionViewCell() }
        
        let imageUrl = model.poster.previewUrl
        let movie: CellViewAnyModel = MovieCollectionViewCellModel(imageUrl: imageUrl)
        
        return collectionView.dequeueReusableCell(withModel: movie, for: indexPath)
    }
}

extension PopularMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.itemPressed(sender: self, for: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
