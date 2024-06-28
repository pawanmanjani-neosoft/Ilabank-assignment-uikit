//
//  SearchBarSection.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import UIKit
import Combine

final class SearchBarSection: UIView {
    var searchbarEvent: CurrentValueSubject<String, Never> = .init("") //Search text change Publisher
    lazy private var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search"
        view.delegate = self
        view.searchBarStyle = .minimal
        view.showsCancelButton = true
        view.barTintColor = UIColor.secondaryLabel
        view.searchTextField.textColor = .black
        view.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        view.searchTextField.leftView?.tintColor = .black
        view.setImage(UIImage(systemName: "x.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .clear, state: .normal)
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
        self.backgroundColor = .white
        self.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    // Reset Search bar text
    func resetSearchBar() {
        searchBar.searchTextField.text = ""
    }
}
// MARK: Searchbar delegate
extension SearchBarSection: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchbarEvent.send(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
