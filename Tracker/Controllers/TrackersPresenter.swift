//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Рамиль Аглямов on 17.12.2023.
//

import Foundation

protocol TrackersPresenterProtocol {
    var view: TrackersViewControllerProtocol? { get }
}

final class TrackersPresenter: TrackersPresenterProtocol {
    weak var view: TrackersViewControllerProtocol?
    
}
