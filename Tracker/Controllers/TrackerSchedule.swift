//
//  TrackerSchedule.swift
//  Tracker
//
//  Created by Рамиль Аглямов on 29.01.2024.
//

import Foundation
import UIKit

final class TrackerSchedule: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    private let weekdays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = weekdays[indexPath.row]
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row // Задаем тэг для переключателя, чтобы знать, с каким днем недели он ассоциирован
        cell.accessoryView = switchView // Устанавливаем переключатель в качестве вспомогательного представления ячейки
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged) // Добавляем обработчик события изменения значения переключателя
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .yBackground
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(setupTableView)
        view.addSubview(saveButton)
        setupTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        setupTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        setupTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        setupTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        setupTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -5).isActive = true
        
        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func saveButtonTapped() {
        // Действия при нажатии на кнопку "Сохранить"
        // Добавление нового трекера в общий список
        dismiss(animated: true, completion: nil)
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
    }
    
    @objc func switchChanged () {
        
    }
}

