//
//  CountryFlagCell.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import UIKit

final class CountryFlagCell: UICollectionViewCell {
    static var identifier: String = "CountryFlagCell" //Identifier for cell
    lazy private var imgViewFlag: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgViewFlag.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        self.backgroundColor = .white
        self.contentView.addSubview(imgViewFlag)
        imgViewFlag.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        imgViewFlag.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        imgViewFlag.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        imgViewFlag.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
    }
    // MARK: set UI from model
    func setData(model: CountryModel) {
        imgViewFlag.image = UIImage(named: model.countryFlagUrl)
    }
}
