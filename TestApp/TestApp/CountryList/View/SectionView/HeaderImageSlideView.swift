//
//  HeaderImageSlideView.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import UIKit
import Combine

final class HeaderImageSlideView: UIView {
    var selectedItemChangedEvent: CurrentValueSubject<Int, Never> = .init(0)
    var listCountries: [CountryModel] = [] {
        didSet {
            pageIndicator.numberOfPages = listCountries.count
            collView.reloadData()
        }
    }
    lazy private var collView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(CountryFlagCell.self, forCellWithReuseIdentifier: CountryFlagCell.identifier)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy private var pageIndicator: UIPageControl = {
        let view = UIPageControl()
        view.isUserInteractionEnabled = false
        view.pageIndicatorTintColor = .lightGray
        view.currentPageIndicatorTintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        self.backgroundColor = .clear
        
        self.addSubview(collView)
        collView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.addSubview(pageIndicator)
        pageIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

// MARK: Collectionview Delegate & Datasource
extension HeaderImageSlideView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCountries.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryFlagCell.identifier, for: indexPath) as! CountryFlagCell
        let model = listCountries[indexPath.row]
        cell.setData(model: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if selectedItemChangedEvent.value != currentPage {
            selectedItemChangedEvent.send(currentPage)
            pageIndicator.currentPage = currentPage
        }
    }
}
