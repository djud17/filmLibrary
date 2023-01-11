//
//  FilterModule.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 09.01.2023.
//

import UIKit
import SnapKit

final class FilterViewController: UIViewController {
    
    // MARK: - Parameters
    
    private var presenter: FilterPresenterProtocol
    
    // MARK: - UI elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.FontSize.large)
        label.textColor = Constants.Color.white
        label.textAlignment = .center
        label.text = "Выберите фильтры"
        
        return label
    }()
    
    private var rating: Float = 0 {
        didSet {
            ratingTitleLabel.text = "Рейтинг фильма от \(rating)"
            ratingSlider.value = rating
        }
    }
    
    private lazy var ratingTitleLabel: UILabel = {
        let label = CustomLabel(withType: .title)
        label.textColor = Constants.Color.white
        label.textAlignment = .left
        label.text = "Рейтинг фильма"
        
        return label
    }()
    
    private lazy var ratingSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Constants.Filter.minRating
        slider.maximumValue = Constants.Filter.maxRating
        slider.backgroundColor = Constants.Color.orange
        slider.tintColor = Constants.Color.white
        
        slider.addTarget(self, action: #selector(ratingSliderValueChanged), for: .valueChanged)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ratingSliderTapped))
        slider.addGestureRecognizer(gesture)
        
        return slider
    }()
    
    private var year: Int = 0 {
        didSet {
            yearTitleLabel.text = "Год выпуска фильма от \(year)"
            yearSlider.value = Float(year)
        }
    }
    
    private lazy var yearTitleLabel: UILabel = {
        let label = CustomLabel(withType: .title)
        label.textColor = Constants.Color.white
        label.textAlignment = .left
        label.text = "Год выпуска фильма"
        
        return label
    }()
    
    private lazy var yearSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Float(Constants.Filter.minYear)
        slider.maximumValue = Float(Constants.Filter.maxYear)
        slider.backgroundColor = Constants.Color.orange
        slider.tintColor = Constants.Color.white
        
        slider.addTarget(self, action: #selector(yearSliderValueChanged), for: .valueChanged)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(yearSliderTapped))
        slider.addGestureRecognizer(gesture)
        
        return slider
    }()
    
    private lazy var submitFiltersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Применить", for: .normal)
        button.setTitleColor(Constants.Color.orange, for: .normal)
        button.setTitleColor(Constants.Color.orange.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = Constants.Color.white
        
        button.layer.cornerRadius = Constants.Size.cornerRadius
        
        button.setupShadow()
        
        button.addTarget(self, action: #selector(submitFiltersButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var resetFiltersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сбросить", for: .normal)
        button.setTitleColor(Constants.Color.orange, for: .normal)
        button.setTitleColor(Constants.Color.orange.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = Constants.Color.white
        
        button.layer.cornerRadius = Constants.Size.cornerRadius
        
        button.setupShadow()
        
        button.addTarget(self, action: #selector(resetFiltersButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Inits
    
    init(presenter: FilterPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
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
        setupFilterValues()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.orange
    }
    
    private func setupHierarchy() {
        view.addSubview(titleLabel)
        
        view.addSubview(ratingTitleLabel)
        view.addSubview(ratingSlider)
        
        view.addSubview(yearTitleLabel)
        view.addSubview(yearSlider)
    }
    
    private func setupLayout() {
        let mediumOffset = Constants.Offset.medium
        let largeOffset = Constants.Offset.large
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        ratingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(largeOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        ratingSlider.snp.makeConstraints { make in
            make.top.equalTo(ratingTitleLabel.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        yearTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingSlider.snp.bottom).offset(largeOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        yearSlider.snp.makeConstraints { make in
            make.top.equalTo(yearTitleLabel.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
        }
        
        setupButtonsBlock()
    }
    
    private func setupFilterValues() {
        (year, rating) = presenter.getFilterValues()
    }
    
    private func setupButtonsBlock() {
        let mediumOffset = Constants.Offset.medium
        let largeOffset = Constants.Offset.large
        
        let buttonsStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.backgroundColor = .clear
            stackView.spacing = mediumOffset
            
            return stackView
        }()
        
        buttonsStackView.addArrangedSubview(submitFiltersButton)
        buttonsStackView.addArrangedSubview(resetFiltersButton)
        
        view.addSubview(buttonsStackView)
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(yearSlider.snp.bottom).offset(largeOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Actions
    
    @objc private func ratingSliderValueChanged() {
        let value = ratingSlider.value
        let roundedValue = round(value * 2.0) * 0.5
        
        rating = Float(roundedValue)
    }
    
    @objc private func yearSliderValueChanged() {
        let value = yearSlider.value
        let roundedValue = round(value)
        
        year = Int(roundedValue)
    }
    
    @objc private func submitFiltersButtonTapped() {
        let maxYear = Int(yearSlider.maximumValue)
        let maxRating = Float(ratingSlider.maximumValue)
        
        presenter.filterSubmit(yearRange: year...maxYear, ratingRange: rating...maxRating)
        
        dismiss(animated: true)
    }
    
    @objc private func resetFiltersButtonTapped() {
        presenter.filterReset()
        year = Int(yearSlider.minimumValue)
        rating = ratingSlider.minimumValue
        
        dismiss(animated: true)
    }
    
    @objc private func yearSliderTapped(_ gesture: UIGestureRecognizer) {
        guard let yearSlider = gesture.view as? UISlider,
              !yearSlider.isHighlighted else { return }
        
        let value = countValue(slider: yearSlider, with: gesture)
        yearSlider.setValue(value, animated: true)
        year = Int(value)
    }
    
    @objc private func ratingSliderTapped(_ gesture: UIGestureRecognizer) {
        guard let ratingSlider = gesture.view as? UISlider,
              !ratingSlider.isHighlighted else { return }
        
        let value = countValue(slider: ratingSlider, with: gesture)
        let roundedValue = round(value * 2.0) * 0.5
        ratingSlider.setValue(roundedValue, animated: true)
        rating = roundedValue
    }
    
    private func countValue(slider: UISlider, with gesture: UIGestureRecognizer) -> Float {
        let tapPoint: CGPoint = gesture.location(in: slider)
        let percentage = tapPoint.x / slider.bounds.size.width
        let delta = Float(percentage) * (slider.maximumValue - slider.minimumValue)
        let value = slider.minimumValue + delta
        
        return value
    }
}
