//
//  TouristPlaceCell.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import UIKit

final class TouristPlaceCell: UITableViewCell {
    static var identifier: String = "TouristPlaceCell" //Identifier for cell
    lazy private var stackH: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 15
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy private var imgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy private var lblName: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(stackH)
        stackH.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        stackH.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12).isActive = true
        stackH.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        stackH.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
        stackH.addArrangedSubview(imgView)
        stackH.addArrangedSubview(lblName)
        
        imgView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    // MARK: set UI from model
    func setData(data: TouristPlaceModel) {
        lblName.text = data.placeName
        imgView.image = UIImage(named: data.placeUrl) ?? UIImage(systemName: "photo.fill")
    }
}
