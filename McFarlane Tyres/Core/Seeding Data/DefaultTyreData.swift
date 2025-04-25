//
//  DefaultTyreData.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  Contains default tyre data including tyre specifications for various widths, profiles, rim sizes and related tyre details.
//

import Foundation

// A Struct is used to represent default tyre data
struct DefaultTyreData {
    let width: String
    let profile: String
    let rimSize: String
    let tyres: [(brand: String, model: String, speedRating: String, price: Double, isWinter: Bool, category: String)]
}

let defaultTyreData: [DefaultTyreData] = [
    DefaultTyreData(width: "195", profile: "65", rimSize: "15", tyres: [
        ("Hankook", "Ventus Prime 3", "H", 70.14, false, "Midrange"),
        ("Michelin", "Energy Saver", "H", 81.06, false, "Premium"),
        ("Goodyear", "EfficientGrip", "H", 75.89, false, "Midrange"),
        ("Nokian", "Line", "T", 78.19, false, "Midrange"),
        ("Uniroyal", "RainExpert 3", "T", 68.99, false, "Economy"),
        ("Falken", "Ziex ZE310 Ecorun", "T", 71.86, false, "Economy"),
        ("Kumho", "Solus TA11", "T", 70.71, false, "Economy"),
        // Winter tyres
        ("Michelin", "Alpin 6", "T", 89.99, true, "Premium"),
        ("Nokian", "WR D4", "T", 77.49, true, "Midrange"),
        ("Falken", "Eurowinter HS01", "T", 80.99, true, "Economy"),
    ]),

    DefaultTyreData(width: "205", profile: "50", rimSize: "17", tyres: [
        ("Pirelli", "Cinturato P7", "W", 103.49, false, "Premium"),
        ("Bridgestone", "Turanza T005", "W", 91.99, false, "Premium"),
        ("Continental", "PremiumContact 6", "W", 98.31, false, "Premium"),
        ("Michelin", "Pilot Sport 4", "V", 98.31, false, "Premium"),
        ("Toyo", "Proxes CF2", "V", 95.44, false, "Midrange"),
        ("Yokohama", "ADVAN Fleva V701", "V", 94.29, false, "Midrange"),
        ("Falken", "Azenis FK510", "V", 105.79, false, "Midrange"),
        // Winter tyres
        ("Continental", "WinterContact TS 860", "H", 102.49, true, "Premium"),
        ("Bridgestone", "Blizzak LM005", "H", 99.89, true, "Premium"),
        ("Nokian", "WR Snowproof", "H", 88.79, true, "Midrange"),
        ("Kumho", "WinterCraft WP71", "T", 83.59, true, "Economy"),
    ]),

    DefaultTyreData(width: "205", profile: "55", rimSize: "16", tyres: [
        ("Goodyear", "EfficientGrip Performance", "H", 75.77, false, "Midrange"),
        ("Michelin", "Energy Saver", "V", 86.24, false, "Premium"),
        ("Toyo", "Proxes CF2", "V", 89.69, false, "Midrange"),
        ("Hankook", "Kinergy Eco 2", "T", 74.74, false, "Midrange"),
        ("Bridgestone", "Turanza T005", "T", 78.76, false, "Premium"),
        ("Kumho", "Solus HA31", "H", 78.19, false, "Midrange"),
        ("Vredestein", "HiTrac", "H", 81.64, false, "Midrange"),
        // Winter tyres
        ("Goodyear", "UltraGrip 9+", "T", 88.49, true, "Midrange"),
        ("Michelin", "Alpin 6", "T", 89.99, true, "Premium"),
        ("Falken", "Eurowinter HS01", "T", 81.49, true, "Economy"),
    ]),

    DefaultTyreData(width: "205", profile: "60", rimSize: "16", tyres: [
        ("Dunlop", "SP Sport BluResponse", "H", 77.04, false, "Midrange"),
        ("Falken", "Ziex ZE310 Ecorun", "T", 68.42, false, "Economy"),
        ("Hankook", "Kinergy Eco 2", "T", 74.74, false, "Midrange"),
        ("Bridgestone", "Turanza T005", "T", 78.76, false, "Premium"),
        ("Nokian", "Line", "T", 73.59, false, "Midrange"),
        ("Firestone", "Multihawk 2", "T", 69.56, false, "Economy"),
        // Winter tyres
        ("Nokian", "WR Snowproof", "T", 82.69, true, "Midrange"),
        ("Michelin", "Alpin 6", "T", 88.99, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "T", 85.39, true, "Economy"),
    ]),

    DefaultTyreData(width: "215", profile: "50", rimSize: "16", tyres: [
        ("Michelin", "Primacy 3", "W", 94.87, false, "Premium"),
        ("Bridgestone", "Turanza T005", "V", 87.99, false, "Premium"),
        ("Falken", "Azenis FK510", "V", 105.79, false, "Midrange"),
        ("Yokohama", "ADVAN Fleva V701", "V", 94.29, false, "Midrange"),
        ("Toyo", "Proxes CF2", "W", 86.81, false, "Midrange"),
        ("Hankook", "Kinergy Eco 2", "T", 74.74, false, "Midrange"),
        ("Continental", "PremiumContact 6", "W", 98.31, false, "Premium"),
        // Winter tyres
        ("Michelin", "Alpin 6", "T", 92.99, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "V", 90.19, true, "Economy"),
    ]),

    DefaultTyreData(width: "215", profile: "55", rimSize: "17", tyres: [
        ("Michelin", "Energy Saver", "V", 83.36, false, "Premium"),
        ("Kumho", "Ecsta PS71", "H", 80.49, false, "Midrange"),
        ("Hankook", "Kinergy 4S", "V", 90.84, false, "Midrange"),
        ("Bridgestone", "Turanza T005", "V", 91.99, false, "Premium"),
        ("Tigar", "HiCity", "V", 64.39, false, "Economy"),
        ("Falken", "Ziex ZE310 Ecorun", "V", 75.89, false, "Midrange"),
        // Winter tyres
        ("Nokian", "WR Snowproof", "H", 87.29, true, "Midrange"),
        ("Michelin", "Alpin 6", "V", 92.59, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "V", 84.19, true, "Economy"),
    ]),

    DefaultTyreData(width: "225", profile: "45", rimSize: "17", tyres: [
        ("Hankook", "Ventus S1 evo3", "W", 106.94, false, "Premium"),
        ("Bridgestone", "Potenza S007", "Y", 114.99, false, "Premium"),
        ("Michelin", "Pilot Sport 4S", "Y", 129.94, false, "Premium"),
        ("Pirelli", "P Zero", "W", 125.33, false, "Premium"),
        ("Goodyear", "Eagle F1 Asymmetric 5", "W", 109.24, false, "Premium"),
        ("Continental", "SportContact 6", "Y", 122.89, false, "Premium"),
        ("Dunlop", "Sport Maxx RT2", "Y", 124.76, false, "Premium"),
        // Winter tyres
        ("Michelin", "Pilot Alpin PA4", "V", 134.29, true, "Premium"),
        ("Falken", "Eurowinter HS01", "V", 103.49, true, "Midrange"),
    ]),

    DefaultTyreData(width: "225", profile: "50", rimSize: "17", tyres: [
        ("Michelin", "Pilot Sport 4", "V", 98.31, false, "Premium"),
        ("Continental", "ContiPremiumContact 6", "W", 101.19, false, "Premium"),
        ("Pirelli", "Cinturato All Season Plus", "V", 101.76, false, "Premium"),
        ("Toyo", "Proxes CF2", "V", 95.44, false, "Midrange"),
        ("Goodyear", "EfficientGrip Performance", "H", 82.49, false, "Midrange"),
        ("Bridgestone", "Turanza T005", "V", 91.99, false, "Premium"),
        // Winter tyres
        ("Michelin", "Alpin 6", "V", 99.49, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "V", 90.19, true, "Economy"),
    ]),

    DefaultTyreData(width: "235", profile: "45", rimSize: "18", tyres: [
        ("Michelin", "Pilot Sport 4S", "Y", 126.49, false, "Premium"),
        ("Pirelli", "Cinturato P7", "W", 113.26, false, "Premium"),
        ("Goodyear", "EfficientGrip", "W", 112.69, false, "Premium"),
        ("Yokohama", "ADVAN Sport V105", "W", 115.99, false, "Premium"),
        ("Continental", "SportContact 6", "Y", 124.76, false, "Premium"),
        ("Bridgestone", "Potenza S001", "Y", 121.99, false, "Premium"),
        // Winter tyres
        ("Nokian", "WR Snowproof", "W", 111.89, true, "Midrange"),
        ("Michelin", "Pilot Alpin PA4", "W", 126.49, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "W", 108.79, true, "Economy"),
    ]),

    DefaultTyreData(width: "235", profile: "50", rimSize: "18", tyres: [
        ("Bridgestone", "Turanzas T005", "V", 109.81, false, "Premium"),
        ("Dunlop", "SP SportMaxx RT2", "W", 103.49, false, "Premium"),
        ("Michelin", "CrossClimate+", "V", 114.99, false, "Premium"),
        ("Hankook", "Ventus S1 evo3", "V", 106.36, false, "Premium"),
        ("Continental", "ContiPremiumContact 6", "W", 101.19, false, "Premium"),
        ("Toyo", "Proxes CF2", "V", 95.44, false, "Midrange"),
        ("Falken", "Azenis FK510", "Y", 92.74, false, "Midrange"),
        ("Nexen", "N'Fera Sport", "Y", 89.99, false, "Economy"),
        // Winter tyres
        ("Michelin", "Alpin 6", "V", 112.49, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "V", 99.19, true, "Economy"),
    ]),

    DefaultTyreData(width: "245", profile: "35", rimSize: "19", tyres: [
        ("Pirelli", "P Zero", "Y", 137.29, false, "Premium"),
        ("Goodyear", "Eagle F1 Asymmetric 6", "Y", 126.49, false, "Premium"),
        ("Michelin", "Pilot Sport 4S", "Y", 138.49, false, "Premium"),
        ("Dunlop", "Sport Maxx RT2", "Y", 132.79, false, "Premium"),
        ("Continental", "SportContact 6", "Y", 128.89, false, "Premium"),
        ("Bridgestone", "Potenza S007", "Y", 134.99, false, "Premium"),
        ("Falken", "Azenis FK520", "Y", 115.39, false, "Midrange"),
        ("Toyo", "Proxes Sport", "Y", 109.89, false, "Midrange"),
        // Winter tyres
        ("Michelin", "Alpin 6", "W", 124.49, true, "Premium"),
        ("Nokian", "WR Snowproof", "W", 118.79, true, "Midrange"),
    ]),

    DefaultTyreData(width: "245", profile: "40", rimSize: "19", tyres: [
        ("Michelin", "Latitude Sport 3", "W", 129.94, false, "Premium"),
        ("Bridgestone", "Potenza S007", "Y", 136.83, false, "Premium"),
        ("Pirelli", "Scorpion Verde All Season", "Y", 142.59, false, "Premium"),
        ("Toyo", "Proxes Sport", "Y", 133.38, false, "Premium"),
        ("Goodyear", "EfficientGrip", "W", 114.99, false, "Premium"),
        ("Continental", "ContiSportContact 5", "W", 121.88, false, "Premium"),
        ("Kumho", "Ecsta PS71", "Y", 108.49, false, "Midrange"),
        ("Hankook", "Ventus S1 evo2", "W", 119.29, false, "Midrange"),
        // Winter tyres
        ("Nokian", "WR Snowproof", "W", 118.99, true, "Midrange"),
        ("Michelin", "Pilot Alpin PA4", "W", 135.99, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "W", 105.49, true, "Economy"),
    ]),

    DefaultTyreData(width: "255", profile: "35", rimSize: "18", tyres: [
        ("Pirelli", "P Zero", "Y", 168.89, false, "Premium"),
        ("Goodyear", "Eagle F1 Asymmetric 5", "W", 175.94, false, "Premium"),
        ("Bridgestone", "Potenza RE050A", "W", 152.94, false, "Premium"),
        ("Michelin", "Pilot Sport 4S", "Y", 172.49, false, "Premium"),
        ("Dunlop", "Sport Maxx RT2", "Y", 183.99, false, "Premium"),
        ("Continental", "SportContact 6", "W", 157.97, false, "Premium"),
        ("Vredestein", "Ultrac Vorti", "Y", 145.69, false, "Midrange"),
        ("Falken", "Azenis FK510", "Y", 139.89, false, "Midrange"),
        // Winter tyres
        ("Michelin", "Alpin 6", "Y", 149.99, true, "Premium"),
        ("Nokian", "WR Snowproof", "Y", 145.49, true, "Midrange"),
    ]),

    DefaultTyreData(width: "265", profile: "35", rimSize: "18", tyres: [
        ("Bridgestone", "Potenza RE050A", "W", 152.94, false, "Premium"),
        ("Michelin", "Pilot Sport 4S", "Y", 172.49, false, "Premium"),
        ("Continental", "ContiSportContact 5", "W", 136.16, false, "Premium"),
        ("Hankook", "Ventus S1 evo3", "W", 144.88, false, "Premium"),
        ("Pirelli", "P Zero", "Y", 159.84, false, "Premium"),
        ("Dunlop", "Sport Maxx RT2", "Y", 149.49, false, "Premium"),
        ("Nexen", "N'Fera Sport", "Y", 139.99, false, "Economy"),
        ("Kumho", "Solus KH17", "H", 122.69, false, "Economy"),
        // Winter tyres
        ("Michelin", "Alpin 6", "W", 148.49, true, "Premium"),
        ("Kumho", "WinterCraft WP71", "W", 130.99, true, "Economy"),
    ]),

    DefaultTyreData(width: "275", profile: "30", rimSize: "18", tyres: [
        ("Pirelli", "P Zero", "Y", 189.74, false, "Premium"),
        ("Goodyear", "Eagle F1 Asymmetric 5", "W", 168.29, false, "Premium"),
        ("Michelin", "Pilot Sport 4S", "Y", 199.94, false, "Premium"),
        ("Dunlop", "Sport Maxx RT2", "Y", 183.99, false, "Premium"),
        ("Continental", "SportContact 6", "W", 167.89, false, "Premium"),
        ("Bridgestone", "Potenza S007", "Y", 186.29, false, "Premium"),
        ("Falken", "Azenis FK510", "Y", 159.89, false, "Midrange"),
        ("Toyo", "Proxes Sport", "Y", 154.39, false, "Midrange"),
        // Winter tyres
        ("Michelin", "Alpin 6", "W", 158.49, true, "Premium"),
        ("Nokian", "WR Snowproof", "W", 153.99, true, "Midrange"),
    ]),

    DefaultTyreData(width: "275", profile: "35", rimSize: "19", tyres: [
        ("Toyo", "Proxes Sport", "Y", 185.71, false, "Premium"),
        ("Bridgestone", "Potenza S007", "Y", 213.89, false, "Premium"),
        ("Michelin", "Pilot Sport 4S", "W", 198.94, false, "Premium"),
        ("Pirelli", "P Zero", "W", 193.19, false, "Premium"),
        ("Goodyear", "Eagle F1 Asymmetric 5", "W", 183.99, false, "Premium"),
        ("Falken", "Azenis FK510", "Y", 179.89, false, "Midrange"),
        ("Nexen", "N'Fera Sport", "Y", 159.99, false, "Midrange"),
        ("Kumho", "Ecsta PS71", "Y", 154.49, false, "Economy"),
        // Winter tyres
        ("Michelin", "Alpin 6", "W", 169.99, true, "Premium"),
        ("Nokian", "WR Snowproof", "W", 164.99, true, "Midrange"),
    ]),

    DefaultTyreData(width: "275", profile: "30", rimSize: "19", tyres: [
        ("Pirelli", "P Zero", "Y", 189.74, false, "Premium"),
        ("Goodyear", "Eagle F1 Asymmetric 5", "W", 168.29, false, "Premium"),
        ("Michelin", "Pilot Sport 4S", "Y", 199.94, false, "Premium"),
        ("Dunlop", "Sport Maxx RT2", "Y", 183.99, false, "Premium"),
        ("Continental", "SportContact 6", "W", 167.89, false, "Premium"),
        ("Bridgestone", "Potenza S007", "Y", 186.29, false, "Premium"),
        ("Falken", "Azenis FK510", "Y", 159.89, false, "Midrange"),
        ("Toyo", "Proxes Sport", "Y", 154.39, false, "Midrange"),
        // Winter tyres
        ("Michelin", "Alpin 6", "W", 158.49, true, "Premium"),
        ("Nokian", "WR Snowproof", "W", 153.99, true, "Midrange"),
    ]),
]
