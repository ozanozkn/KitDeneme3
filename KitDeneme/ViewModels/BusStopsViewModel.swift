//
//  BusStopsViewModel.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 28.03.2024.
//

import Foundation
import MapKit

protocol BusStopsViewModelDelegate: AnyObject {
    func didLoadBusStopsData(_ stops: [Stop])
    func didFailLoadingBusStopsData(_ error: Error)
}

class BusStopsViewModel {
    
    weak var delegate: BusStopsViewModelDelegate?
    
    private var busStops: [Stop] = []
    
    func loadBusStopsData() {
        guard let busStopsData = try? Data(contentsOf: Bundle.main.url(forResource: "bus_stops", withExtension: "json")!) else {
            delegate?.didFailLoadingBusStopsData(NSError(domain: "BusStopsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load bus stops data"]))
            return
        }
        
        do {
            let busStopsResponseModel = try JSONDecoder().decode(BusStopsResponseModel.self, from: busStopsData)
            busStops = busStopsResponseModel.stops
            delegate?.didLoadBusStopsData(busStops)
        } catch {
            delegate?.didFailLoadingBusStopsData(error)
        }
    }
}
