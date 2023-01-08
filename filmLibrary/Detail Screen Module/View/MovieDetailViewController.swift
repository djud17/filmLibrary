//
//  DetailViewController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 06.01.2023.
//

import SnapKit
import Kingfisher

protocol MovieDetailDelegate: AnyObject {
    func setupPosterImage(with url: String)
    func setupMovieName(with text: String)
    func setupMovieDescription(with text: String)
    func setupInfoBlock(rating: Double, duration: Int)
    func updateActorsBlock()
}

final class MovieDetailViewController: UIViewController {
    private var presenter: MovieDetailPresenterProtocol
    
    // MARK: - UI Elements

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.white
        view.layer.cornerRadius = Constants.Size.cornerRadius
        return view
    }()
    
    private let moviePoster: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = Constants.Color.white
        imageView.layer.cornerRadius = Constants.Size.cornerRadius
        imageView.clipsToBounds = true
        imageView.layer.borderColor = Constants.Color.orange.cgColor
        imageView.layer.borderWidth = 4
        
        return imageView
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.FontSize.titleLabel)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.FontSize.textLabel)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    private let movieInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.FontSize.textLabel)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let actorsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 50, height: 80)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Constants.Color.orange
        collectionView.alwaysBounceHorizontal = true
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = Constants.Color.white
        return scrollView
    }()
    
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
        
        presenter.loadData()
        presenter.loadMovieInfo()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.orange
        
        actorsCollectionView.register(nibModels: [ActorCollectionViewCellModel.self])
        actorsCollectionView.dataSource = self
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure
dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit
anim id est laborum.Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium
doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi
architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit
aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione
voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor
sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora
incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad
minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam,
nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit
qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui
dolorem eum fugiat quo voluptas nulla pariatur?
"""
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        let smallOffset = Constants.Offset.small
        let mediumOffset = Constants.Offset.medium
        
        let imageOffset = 170 / 2
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
        let contentView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        scrollView.addSubview(contentView)
        contentView.addSubview(movieDescriptionLabel)
        contentView.addSubview(actorsCollectionView)
        contentView.addSubview(titleLabel)
        
        setupContentViewLayout(for: contentView)
    }
    
    private func setupContentViewLayout(for contentView: UIView) {
        let smallOffset = Constants.Offset.small
        let mediumOffset = Constants.Offset.medium
        
        scrollView.snp.makeConstraints { make in
            make.centerX.equalTo(backView.snp.centerX)
            make.width.equalTo(backView.snp.width)
            make.top.equalTo(moviePoster.snp.bottom).offset(mediumOffset)
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
        
        let actorsTitleLabel = createTitleLabel(with: "Актёры:")
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
            make.height.equalTo(Constants.Size.smallImageHeight)
        }
        
        let factsTitleLabel = createTitleLabel(with: "Интересные факты о фильме:")
        contentView.addSubview(factsTitleLabel)
        
        factsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(actorsCollectionView.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(factsTitleLabel.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    private func createTitleLabel(with text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: Constants.FontSize.titleLabel)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.text = text

        return titleLabel
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
