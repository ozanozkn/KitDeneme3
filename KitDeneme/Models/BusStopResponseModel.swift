//
//  BusStopResponseModel.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 20.03.2024.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let busStopsResponseModel = try? JSONDecoder().decode(BusStopsResponseModel.self, from: jsonData)

import Foundation

// MARK: - BusStopsResponseModel
struct BusStopsResponseModel: Codable {
    let lastUpdated: Int
    let stops: [Stop]

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case stops
    }
}

// MARK: - Stop
struct Stop: Codable {
    let stopID: Int
    let atcoCode, name: String
    let identifier: String?
    let locality: String
    let orientation: Int
    let direction: Direction?
    let latitude, longitude: Double
    let serviceType: ServiceType
    let atcoLatitude, atcoLongitude: Double
    let destinations: [Destination]
    let services: [String]

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case atcoCode = "atco_code"
        case name, identifier, locality, orientation, direction, latitude, longitude
        case serviceType = "service_type"
        case atcoLatitude = "atco_latitude"
        case atcoLongitude = "atco_longitude"
        case destinations, services
    }
}

enum Destination: String, Codable {
    case aberlady = "Aberlady"
    case airport = "Airport"
    case balerno = "Balerno"
    case bathgate = "Bathgate"
    case blackburn = "Blackburn"
    case bonaly = "Bonaly"
    case bonnyrigg = "Bonnyrigg"
    case cammo = "Cammo"
    case cityCentre = "City Centre"
    case clermiston = "Clermiston"
    case clerwood = "Clerwood"
    case clovenstone = "Clovenstone"
    case dalkeithCampus = "Dalkeith Campus"
    case dunbar = "Dunbar"
    case eastCraigs = "East Craigs"
    case easterBush = "Easter Bush"
    case eastfield = "Eastfield"
    case edinburgh = "Edinburgh"
    case elmRow = "Elm Row"
    case fairmilehead = "Fairmilehead"
    case fauldhouse = "Fauldhouse"
    case fortKinnaird = "Fort Kinnaird"
    case fountainbridge = "Fountainbridge"
    case gorebridge = "Gorebridge"
    case granton = "Granton"
    case grantonHarbour = "Granton Harbour"
    case greenbank = "Greenbank"
    case greendykes = "Greendykes"
    case gyleCentre = "Gyle Centre"
    case haddington = "Haddington"
    case haymarket = "Haymarket"
    case heriotWattUni = "Heriot-Watt Uni"
    case hermistonGait = "Hermiston Gait"
    case hunterSTryst = "Hunter's Tryst"
    case hyvotsBank = "Hyvots Bank"
    case kingSBuildings = "King's Buildings"
    case kingSRoad = "King's Road"
    case kirkliston = "Kirkliston"
    case livingston = "Livingston"
    case longniddry = "Longniddry"
    case mayfield = "Mayfield"
    case midlothianCommunityHospital = "Midlothian Community Hospital"
    case millerhill = "Millerhill"
    case muirhouse = "Muirhouse"
    case musselburgh = "Musselburgh"
    case newhaven = "Newhaven"
    case newtongrange = "Newtongrange"
    case northBerwick = "North Berwick"
    case oceanTerminal = "Ocean Terminal"
    case ormiston = "Ormiston"
    case pencaitland = "Pencaitland"
    case penicuik = "Penicuik"
    case penicuikDeanburn = "Penicuik Deanburn"
    case penicuikLadywood = "Penicuik Ladywood"
    case poltonMill = "Polton Mill"
    case portSeton = "Port Seton"
    case portobello = "Portobello"
    case prestonLodge = "Preston Lodge"
    case queenMargaretUni = "Queen Margaret Uni"
    case queensferry = "Queensferry"
    case restalrig = "Restalrig"
    case rosewell = "Rosewell"
    case royalInfirmary = "Royal Infirmary"
    case seafield = "Seafield"
    case setonSands = "Seton Sands"
    case silverknowes = "Silverknowes"
    case southGyle = "South Gyle"
    case stJohnSHospital = "St. John's Hospital"
    case surgeonsHall = "Surgeons' Hall"
    case theJewel = "The Jewel"
    case torphin = "Torphin"
    case tranent = "Tranent"
    case trinity = "Trinity"
    case wallyford = "Wallyford"
    case waterlooPlace = "Waterloo Place"
    case westGranton = "West Granton"
    case westerHailes = "Wester Hailes"
    case westernGeneralHospital = "Western General Hospital"
    case westernHarbour = "Western Harbour"
    case westsidePlaza = "Westside Plaza"
    case whitburn = "Whitburn"
    case whitecraig = "Whitecraig"
}

enum Direction: String, Codable {
    case e = "E"
    case n = "N"
    case ne = "NE"
    case nw = "NW"
    case s = "S"
    case se = "SE"
    case sw = "SW"
    case w = "W"
}

enum ServiceType: String, Codable {
    case bus = "bus"
    case tram = "tram"
}
