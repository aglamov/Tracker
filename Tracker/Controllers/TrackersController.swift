//
//  ViewController.swift
//  Tracker
//
//  Created by Рамиль Аглямов on 16.12.2023.

import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenterProtocol? { get }
    var trackersCollectionView: UICollectionView { get }
    var currentDate: Date? { get }
    func didSelectDate(_ date: Date)
}

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentDate: Date?
    
    var presenter: TrackersPresenterProtocol?
    var trackerCategories: [TrackerCategory] {
        return TrackerCategoryManager.shared.trackerCategories
    }
    var visibleTrackerCategories: [TrackerCategory] = []
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        
        let tracker = visibleTrackerCategories[indexPath.section].trackers[indexPath.item]
        cell.id = tracker.id
        cell.titleLabel.text = tracker.name
        cell.delegate = self
               cell.currentDate = currentDate

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalInsets: CGFloat = 16 * 3
        let width: CGFloat = min((collectionView.bounds.width - horizontalInsets) / 2, 196)
        let height: CGFloat = 130
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleTrackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTrackerCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            headerView.titleLabel.text = visibleTrackerCategories[indexPath.section].name
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 19)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 16, bottom: 24, right: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visibleTrackerCategories = trackerCategories
        trackersCollectionView.reloadData()
        checkEmptyState()
    }
    
    lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18 // Расстояние между ячейками по вертикали
        layout.minimumInteritemSpacing = 8 // Расстояние между ячейками по горизонтали
        layout.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16) // Отступы от краёв экрана
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        return collectionView
    }()
    
    
    private lazy var datePickerButton: UIBarButtonItem = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setDateForTrackers), for: .valueChanged)
        let dateButton = UIBarButtonItem(customView: datePicker)
        return dateButton
    }()
    
    private lazy var emptyScreenImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "EmptyTackers")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyScreenText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var emptyScreenView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyScreenImage)
        view.addSubview(emptyScreenText)
        
        return view
    }()
    
    private func checkEmptyState() {
        if visibleTrackerCategories.isEmpty {
            emptyScreenImage.isHidden = false
            emptyScreenText.isHidden = false
        } else {
            emptyScreenImage.isHidden = true
            emptyScreenText.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackersScreen()
        visibleTrackerCategories = trackerCategories
        trackersCollectionView.delegate = self
        currentDate = Date() 
    }
    
    private func setupTrackersScreen() {
        view.backgroundColor = .white
        setupNavigationBar()
        addSubviews()
        constraintSubviews()
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationBar.topItem?.setLeftBarButton(addButton, animated: true)
        
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = datePickerButton
    }
    
    func didSelectDate(_ date: Date) {
        currentDate = date
    }
    
    
    private func addSubviews() {
        view.addSubview(emptyScreenView)
        view.addSubview(trackersCollectionView)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyScreenText.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            emptyScreenText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func filteredTrackerCategories(for weekday: Int) -> [TrackerCategory] {
        return trackerCategories.filter({ (category) in
            category.trackers.contains(where: { (tracker) in
                tracker.schedule.contains(weekday)
            })
        })
    }
    
    @objc private func addButtonTapped() {
        let trackerCreation = TrackerCreationViewController()
        let navController = UINavigationController(rootViewController: trackerCreation)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc private func setDateForTrackers(_ sender: UIDatePicker) {
        let date = sender.date
        currentDate = date
        let weekday = Calendar.current.component(.weekday, from: date)
        var filteredCategories: [TrackerCategory] = []
        
        for category in TrackerCategoryManager.shared.trackerCategories {
            let filteredTrackers = category.trackers.filter { $0.schedule.contains(weekday) || $0.type == .unregularEvent }
            if !filteredTrackers.isEmpty {
                let filteredCategory = TrackerCategory(name: category.name, trackers: filteredTrackers)
                filteredCategories.append(filteredCategory)
            }
        }
        visibleTrackerCategories = filteredCategories
        checkEmptyState()
        trackersCollectionView.reloadData()
    }
    
}

