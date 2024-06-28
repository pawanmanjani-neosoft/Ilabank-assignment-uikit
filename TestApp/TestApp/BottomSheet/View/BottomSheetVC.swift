//
//  BottomSheetView.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import UIKit
import Combine

final class BottomSheetVC: UIViewController {
    var countrydata: [CountryModel] = []
    private let viewModel: BottomSheetVMProtocol = BottomSheetVM()
    private var cancellable = Set<AnyCancellable>()
    lazy private var tblView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    init(countrydata: [CountryModel]) {
        self.countrydata = countrydata
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        setUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.setupData(countryData: countrydata)
        addCloseItem()
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
    }
    private func addCloseItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(closeSheet))
    }
    @objc private func closeSheet() {
        self.dismiss(animated: true)
    }
    // MARK: Binding data
    private func bindData() {
        viewModel.reloadEvent.receive(on: RunLoop.main).sink { [weak self] in
            guard let self else { return }
            self.tblView.reloadData()
        }.store(in: &cancellable)
    }
}
// MARK: Tableview Delegate & Datasource
extension BottomSheetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let model = viewModel.displayData[indexPath.row]
        cell?.textLabel?.text = model.title
        cell?.detailTextLabel?.text = model.detailTxt
        cell?.detailTextLabel?.numberOfLines = 0
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BottomSheetVC {
    // MARK: Initialization process for Bottom sheet
    static func initializeWith(countryData: [CountryModel]) -> UIViewController {
        let bottomSheetVC = BottomSheetVC(countrydata: countryData)
        let nav = UINavigationController(rootViewController: bottomSheetVC)
        return nav
    }
}
