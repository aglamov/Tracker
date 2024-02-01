//
//   TrackerCreation2Controller.swift
//  Tracker
//
//  Created by Рамиль Аглямов on 25.01.2024.
//

import Foundation
import UIKit

final class TrackerCreation2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var selectedType: TrackerType
    var selectedCategory: String = ""
    
    init(selectedType: TrackerType) {
        self.selectedType = selectedType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .yBackground
        textField.layer.cornerRadius = 16
        textField.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: [NSAttributedString.Key.foregroundColor: UIColor.yGray])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.yRed, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.yRed.cgColor
        
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .yGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var setupTableView: UITableView = {
        let planningTableView = UITableView(frame: .zero, style: .insetGrouped)
        planningTableView.translatesAutoresizingMaskIntoConstraints = false
        planningTableView.separatorStyle = .singleLine
        planningTableView.contentInsetAdjustmentBehavior = .never
        planningTableView.backgroundColor = .white
        planningTableView.isScrollEnabled = true
        planningTableView.showsVerticalScrollIndicator = false
        planningTableView.dataSource = self
        planningTableView.delegate = self
        planningTableView.allowsSelection = true
        
        return planningTableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView.reloadData() // Обновляем таблицу при возвращении на экран
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .yBackground
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentTrackerType = selectedType
        return currentTrackerType == .habit ? 2: 1
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    //            cell.accessoryType = .disclosureIndicator
    //
    //            if indexPath.row == 0 {
    //                cell.textLabel?.text = selectedCategory ?? "Выберите категорию"
    //            } else if indexPath.row == 1 {
    //                cell.textLabel?.text = "Расписание"
    //            }
    //
    //            return cell
    //        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if indexPath.row == 0 {
            if selectedCategory == "" { cell.textLabel?.text = "Выберите категорию" } else {
                cell.textLabel?.text = "Категория"
                cell.detailTextLabel?.text = selectedCategory
                cell.detailTextLabel?.textColor = .gray
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            }
            
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            scheduleButtonTapped()
            return
        }
        if indexPath.row == 0 {
            categoryButtonTapped()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(trackerNameTextField)
        
        view.addSubview(setupTableView)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        setupTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        trackerNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        trackerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        trackerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        trackerNameTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        setupTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 123).isActive = true
        setupTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        setupTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        setupTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20).isActive = true
        
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func scheduleButtonTapped() {
        let trackerCreation = TrackerSchedule()
        let navController = UINavigationController(rootViewController: trackerCreation)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func categoryButtonTapped() {
        let trackerCreation = TrackerCategoryViewController()
        trackerCreation.delegate = self
        let navController = UINavigationController(rootViewController: trackerCreation)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        // Действия при нажатии на кнопку "Сохранить"
        // Добавление нового трекера в общий список
        dismiss(animated: true, completion: nil)
    }
    
}

extension TrackerCreation2ViewController: CategorySelectionDelegate {
    
    func didSelectCategory(_ category: String) {
        selectedCategory = category
        setupTableView.reloadData()
    }
}
