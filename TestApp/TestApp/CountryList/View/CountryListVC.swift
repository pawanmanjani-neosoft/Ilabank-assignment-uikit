//
//  CountryListVC.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import UIKit
import Combine

final class CountryListVC: UIViewController {
    private let viewModel: CountryListVMProtocol = CountryListVM()
    private var cancellable = Set<AnyCancellable>()
    private var viewSearchBar: SearchBarSection = SearchBarSection()
    lazy private var tblView: UITableView = {
        let view = UITableView()
        view.tableHeaderView = headerSlideView
        view.backgroundColor = .clear
        view.register(TouristPlaceCell.self, forCellReuseIdentifier: TouristPlaceCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy private var headerSlideView: HeaderImageSlideView = {
        let view = HeaderImageSlideView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy private var floatingBtn: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        view.backgroundColor = UIColor.black
        view.tintColor = .white
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func loadView() {
        super.loadView()
        setUI()
        setAction()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.loadData()
    }
    private func setUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(tblView)
        tblView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tblView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tblView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tblView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tblView.sectionHeaderTopPadding = 0
        tblView.contentInset.bottom = 80
        
        self.view.addSubview(floatingBtn)
        floatingBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -25).isActive = true
        floatingBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        floatingBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        floatingBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        headerSlideView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        headerSlideView.heightAnchor.constraint(equalToConstant: 230).isActive = true
    }
    // MARK: Setting tableview data
    private func setTableViewData() {
        self.tblView.removeEmptyMessage()
        if viewModel.isFilterPlacesIsEmpty {
            self.tblView.showEmptyMessage()
        }
        self.tblView.reloadData()
    }
    // MARK: Binding data
    private func bindData() {
        viewModel.reloadEvent.receive(on: RunLoop.main).sink { [weak self] in
            guard let self else { return }
            self.setTableViewData()
        }.store(in: &cancellable)
        viewModel.dataReceivedEvent.receive(on: RunLoop.main).sink { [weak self] in
            guard let self else { return }
            self.headerSlideView.listCountries = viewModel.getListOfCountry
        }.store(in: &cancellable)
        viewModel.errorEvent.receive(on: RunLoop.main).sink { [weak self] msg in
            guard let self else { return }
            let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
            self.present(alert, animated: true)
        }.store(in: &cancellable)
        headerSlideView.selectedItemChangedEvent.receive(on: RunLoop.main).sink { [weak self] index in
            guard let self else { return }
            viewModel.setTouristListBy(index: index)
        }.store(in: &cancellable)
        headerSlideView.selectedItemChangedEvent.receive(on: RunLoop.main).sink { [weak self] index in
            guard let self else { return }
            viewModel.setTouristListBy(index: index)
            viewSearchBar.resetSearchBar()
        }.store(in: &cancellable)
        viewSearchBar.searchbarEvent.receive(on: RunLoop.main).sink { [weak self] txt in
            guard let self else { return }
            viewModel.filterDataby(txt)
        }.store(in: &cancellable)
    }
    // MARK: Setting Action
    private func setAction() {
        let actionFloating = UIAction { [weak self] _ in
            guard let self else { return }
            let bottomVC = BottomSheetVC.initializeWith(countryData: viewModel.getListOfCountry)
            if let sheet = bottomVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            self.present(bottomVC, animated: true)
        }
        floatingBtn.addAction(actionFloating, for: .touchUpInside)
    }
}
// MARK: Tableview Delegate & Datasource
extension CountryListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TouristPlaceCell.identifier, for: indexPath) as! TouristPlaceCell
        let model = viewModel.filterData[indexPath.row]
        cell.setData(data: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewSearchBar.frame = tableView.frame
        return viewSearchBar
    }
}
