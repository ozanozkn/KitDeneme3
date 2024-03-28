//
//  BusLocationsViewModel.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 28.03.2024.
//

import Foundation

protocol BusLocationsViewModelDelegate: AnyObject {
    func didUpdateBusLocations(_ locations: [Vehicle])
    func didFailFetchingBusLocations(with error: Error)
}

class BusLocationsViewModel {
    weak var delegate: BusLocationsViewModelDelegate?

    func fetchLiveBusLocations() {
        let endpoint = "https://tfe-opendata.com/api/v1/vehicle_locations"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.didFailFetchingBusLocations(with: error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let busLocationsResponseModel = try decoder.decode(BusLocationsResponseModel.self, from: data)
                
                print("DEBUG PRINT:", "success decoding")
                
                self.delegate?.didUpdateBusLocations(busLocationsResponseModel.vehicles)
            } catch {
                self.delegate?.didFailFetchingBusLocations(with: error)
            }
        }
        
        task.resume()
    }
}
