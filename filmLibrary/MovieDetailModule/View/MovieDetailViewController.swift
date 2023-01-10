//
//  DetailViewController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 06.01.2023.
//

import UIKit
import SnapKit

protocol MovieDetailDelegate: AnyObject {
    func setupPosterImage(with url: String)
    func setupMovieName(with text: String)
    func setupMovieDescription(with text: String)
    func setupInfoBlock(rating: Double, duration: Int)
    func updateActorsBlock()
    func setupFactsBlock()
}

final class MovieDetailViewController: UIViewController {
    
    // MARK: - UI Elements

    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.white
        view.layer.cornerRadius = Constants.Size.cornerRadius
        
        view.setupShadow()
        
        return view
    }()
    
    private lazy var moviePoster: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = Constants.Color.white
        imageView.layer.cornerRadius = Constants.Size.cornerRadius
        imageView.clipsToBounds = true
        imageView.layer.borderColor = Constants.Color.orange.cgColor
        imageView.layer.borderWidth = Constants.Size.borderWidth
        
        imageView.setupShadow()
        
        return imageView
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let label = CustomLabel(withType: .title)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var movieDescriptionLabel = CustomLabel(withType: .normal)
    
    private lazy var movieInfoLabel: UILabel = {
        let label = CustomLabel(withType: .normal)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var actorsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let inset = Constants.Offset.smallCellInset
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(width: Constants.Size.smallImageSize, height: Constants.Size.smallImageSize)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Constants.Color.orange
        collectionView.layer.cornerRadius = Constants.Size.cornerRadius
        collectionView.allowsSelection = false
        
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = Constants.Color.white
        
        return scrollView
    }()
    
    private lazy var factsBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var watchListButton: WatchListButton = {
        let button = WatchListButton(buttonStyle: .notAdded)
        button.addTarget(self, action: #selector(watchListButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Parameters
    
    private var presenter: MovieDetailPresenterProtocol
    private let smallOffset = Constants.Offset.small
    private let mediumOffset = Constants.Offset.medium
    private let largeOffset = Constants.Offset.large
    
    // MARK: - Inits
    
    init(presenter: MovieDetailPresenterProtocol) {
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
        
        setupBackViewHierarchy()
        setupBackViewLayout()
        setupContentViewHierarchy()
        setupWatchListButton()
        
        presenter.loadData()
        presenter.loadMovieInfo()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.orange
        
        actorsCollectionView.register(nibModels: [ActorCollectionViewCellModel.self])
        actorsCollectionView.dataSource = self
    }
    
    private func setupHierarchy() {
        view.addSubview(backView)
    }
    
    private func setupLayout() {
        let mediumOffset = Constants.Offset.medium
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.Offset.large)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(mediumOffset)
        }
    }
    
    // MARK: - BackView setups
    
    private func setupBackViewHierarchy() {
        backView.addSubview(moviePoster)
        backView.addSubview(movieNameLabel)
        backView.addSubview(movieInfoLabel)
        backView.addSubview(scrollView)
    }
    
    private func setupBackViewLayout() {
        let imageOffset = Constants.Size.imageHeight / 2
        moviePoster.snp.makeConstraints { make in
            make.bottom.equalTo(backView.snp.top).offset(imageOffset)
            make.leading.equalTo(backView.snp.leading).offset(mediumOffset)
            make.width.equalTo(Constants.Size.imageWidth)
            make.height.equalTo(Constants.Size.imageHeight)
        }
        
        movieNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(mediumOffset)
            make.leading.equalTo(moviePoster.snp.trailing).offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        movieInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(movieNameLabel.snp.bottom).offset(smallOffset)
            make.leading.equalTo(moviePoster.snp.trailing).offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
    }
    
    private func setupContentViewHierarchy() {
        let contentView = UIView()
        contentView.backgroundColor = Constants.Color.white
        
        scrollView.addSubview(contentView)
        contentView.addSubview(movieDescriptionLabel)
        contentView.addSubview(actorsCollectionView)
        contentView.addSubview(factsBlock)
        
        setupContentViewLayout(for: contentView)
    }
    
    private func setupContentViewLayout(for contentView: UIView) {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(movieInfoLabel.snp.bottom).offset(largeOffset)
            make.centerX.equalTo(backView.snp.centerX)
            make.width.equalTo(backView.snp.width)
            make.bottom.equalTo(backView.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        movieDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        setupActorsBlockLayout(in: contentView)
        setupFactsBlockLayout(in: contentView)
    }
    
    private func setupActorsBlockLayout(in contentView: UIView) {
        let actorsTitleLabel = CustomLabel(withType: .title)
        actorsTitleLabel.text = "Актёры:"
        contentView.addSubview(actorsTitleLabel)
        
        actorsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDescriptionLabel.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }

        actorsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(actorsTitleLabel.snp.bottom).offset(smallOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.height.equalTo(Constants.Size.smallCellHeight)
        }
    }
    
    private func setupFactsBlockLayout(in contentView: UIView) {
        let factsTitleLabel = CustomLabel(withType: .title)
        factsTitleLabel.text = "Интересные факты:"
        contentView.addSubview(factsTitleLabel)
        
        factsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(actorsCollectionView.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        factsBlock.snp.makeConstraints { make in
            make.top.equalTo(factsTitleLabel.snp.bottom).offset(smallOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupWatchListButton() {
        backView.addSubview(watchListButton)
        
        let watchListButtonOffset: CGFloat = 15
        watchListButton.snp.makeConstraints { make in
            make.bottom.equalTo(moviePoster.snp.bottom).offset(watchListButtonOffset)
            make.trailing.equalTo(moviePoster.snp.trailing).offset(watchListButtonOffset)
            make.height.width.equalTo(Constants.Size.watchListButton)
        }
        
        let resultCheck = presenter.checkWatchList()
        watchListButton.buttonStyle = resultCheck ? .added : .notAdded
    }
    
    // MARK: - Actions
    
    @objc private func watchListButtonTapped(_ sender: WatchListButton) {
        let buttonStyle = sender.buttonStyle
        switch buttonStyle {
        case .added:
            sender.buttonStyle = .notAdded
        case .notAdded:
            sender.buttonStyle = .added
        }
        
        presenter.watchListButtonTapped()
    }
}

extension MovieDetailViewController: MovieDetailDelegate {
    func setupPosterImage(with url: String) {
        moviePoster.setupImage(with: url)
    }
    
    func setupMovieName(with text: String) {
        movieNameLabel.text = text
    }
    
    func setupMovieDescription(with text: String) {
        movieDescriptionLabel.text = text
    }
    
    func setupInfoBlock(rating: Double, duration: Int) {
        movieInfoLabel.text = "\(rating), \(duration) мин."
    }
    
    func updateActorsBlock() {
        actorsCollectionView.reloadData()
    }
    
    func setupFactsBlock() {
        let facts = presenter.getFacts()
        
        var underView = factsBlock.snp.top
        for (index, fact) in facts.enumerated() {
            let factView = createFactView(with: fact)
            factsBlock.addSubview(factView)
            
            factView.snp.makeConstraints { make in
                make.top.equalTo(underView).offset(smallOffset)
                make.trailing.leading.equalToSuperview()
                
                if index == facts.count - 1 {
                    make.bottom.equalToSuperview().inset(smallOffset)
                }
            }
            
            underView = factView.snp.bottom
        }
    }
    
    private func createFactView(with fact: String) -> UIView {
        let view = UIView()
        view.backgroundColor = Constants.Color.orange
        view.layer.cornerRadius = Constants.Size.cornerRadius
        
        let factLabel = CustomLabel(withType: .fact)
        factLabel.text = fact

        view.addSubview(factLabel)
        
        factLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(smallOffset)
            make.bottom.trailing.equalToSuperview().inset(smallOffset)
        }
        
        return view
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfActors()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = presenter.getData(for: indexPath.row) else { return UICollectionViewCell() }
        
        let imageUrl = model.photo ?? ""
        let actor: CellViewAnyModel = ActorCollectionViewCellModel(imageUrl: imageUrl)
        
        return collectionView.dequeueReusableCell(withModel: actor, for: indexPath)
    }
}
