//
//  TrackerManager.swift
//  Tracker
//
//  Created by Рамиль Аглямов on 02.02.2024.

import Foundation

class TrackerManager {
    static let shared = TrackerManager()
    private init() {}
    
    var trackers: [Tracker] = []
    
    func addTracker(_ tracker: Tracker) {
        trackers.append(tracker)
    }
}

class TrackerCategoryManager {
    static let shared = TrackerCategoryManager()
    private init() {}
    
    var trackerCategories: [TrackerCategory] = []
    
    func addNewTrackerCategories(_ newCategory: TrackerCategory) {
        trackerCategories.append(newCategory)
    }
    
    func addTrackerToCategory(_ newTracker: Tracker, categoryName: String) {
        if let index = trackerCategories.firstIndex(where: { $0.name == categoryName }) {
            trackerCategories[index].trackers.append(newTracker)
        }
    }
}

class TrackerRecordManager {
    static let shared = TrackerRecordManager()
    
    var trackerRecords: Set<TrackerRecord> = []
    
    private init() {}
    
    func addTrackerRecord(id: UUID, date: Date) {
        let trackerRecord = TrackerRecord(id: id, date: date)
        trackerRecords.insert(trackerRecord)
    }
    
    func removeTrackerRecord(withID id: UUID) {
        if let recordToRemove = trackerRecords.first(where: { $0.id == id }) {
            trackerRecords.remove(recordToRemove)
        }
    }
    
    func getTrackerRecords() -> Set<TrackerRecord> {
        return trackerRecords
    }
}


