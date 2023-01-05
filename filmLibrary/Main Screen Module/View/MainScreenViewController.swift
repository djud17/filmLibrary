//
//  ViewController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import UIKit
import SnapKit

protocol MainScreenDelegate: AnyObject {
    func updateView()
}

final class MainScreenViewController: UIViewController {
    private var presenter: MainScreenPresenterProtocol = MainScreenPresenter()
    
    private let moviesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 120, height: 170)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private var startDataNumber = 298
    private var isLoadMoreData = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter.delegate = self
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
        view.backgroundColor = Constants.Color.blue
        
        navigationItem.title = "Все фильмы"
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
        presenter.loadData(from: startDataNumber)
    }
}

extension MainScreenViewController: MainScreenDelegate {
    func updateView() {
        moviesCollectionView.reloadData()
    }
}

extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfRecords()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = presenter.getData(for: indexPath.row) else { return UICollectionViewCell() }
        
        let imageUrl = model.poster.url
        let movie: CellViewAnyModel = MovieCollectionViewCellModel(imageUrl: imageUrl)
        
        return collectionView.dequeueReusableCell(withModel: movie, for: indexPath)
    }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let index = presenter.getNumberOfRecords() - (Constants.downloadDataNumber / 2)
        
        if indexPath.row == index {
            isLoadMoreData = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let index = presenter.getNumberOfRecords() - (Constants.downloadDataNumber / 2)
        
        if (indexPath.row == index) && isLoadMoreData {
            startDataNumber += Constants.downloadDataNumber
            presenter.loadData(from: startDataNumber)
            isLoadMoreData = false
        }
    }
}

extension UICollectionView {
    func dequeueReusableCell(withModel model: CellViewAnyModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: type(of: model).cellAnyType)
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        model.setupAny(cell: cell)
        
        return cell
    }
    
    func register(nibModels: [CellViewAnyModel.Type]) {
        for model in nibModels {
            let identifier = String(describing: model.cellAnyType)
            let nib = UINib(nibName: identifier, bundle: nil)
            self.register(nib, forCellWithReuseIdentifier: identifier)
        }
    }
}
