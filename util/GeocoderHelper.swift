//
//  GeocoderHelper.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/31/23.
//

import Foundation


struct AddressVerdict: Codable {
    let inputGranularity: String
    let validationGranularity: String
    let geocodeGranularity: String
    let addressComplete: Bool
    let hasInferredComponents: Bool
}

struct AddressComponentName: Codable {
    let text: String
    let languageCode: String?
}

struct AddressComponent: Codable {
    let componentName: AddressComponentName
    let componentType: String
    let confirmationLevel: String
    let inferred: Bool?
}

struct PostalAddress: Codable {
    let regionCode: String
    let languageCode: String?
    let postalCode: String
    let administrativeArea: String
    let locality: String
    let addressLines: [String]
}

struct AddressData: Codable {
    let formattedAddress: String
    let postalAddress: PostalAddress
    let addressComponents: [AddressComponent]
}

struct GeocodeLocation: Codable {
    let latitude: Double
    let longitude: Double
}

struct GeocodePlusCode: Codable {
    let globalCode: String
}

struct GeocodeBounds: Codable {
    let low: GeocodeLocation
    let high: GeocodeLocation
}

struct GeocodeData: Codable {
    let location: GeocodeLocation
    let plusCode: GeocodePlusCode
    let bounds: GeocodeBounds
    let featureSizeMeters: Double
    let placeId: String
    let placeTypes: [String]
}

struct USPSData: Codable {
    let standardizedAddress: StandardizedAddress
    let deliveryPointCode: String
    let deliveryPointCheckDigit: String
    // Add other properties as needed
}

struct StandardizedAddress: Codable {
    let firstAddressLine: String
    let cityStateZipAddressLine: String
    let city: String
    let state: String
    let zipCode: String
    let zipCodeExtension: String
}

struct ApiResponse: Codable {
    let result: ResultData
    let responseId: String
}

struct ResultData: Codable {
    let verdict: AddressVerdict
    let address: AddressData
    let geocode: GeocodeData
    let metadata: Metadata
    let uspsData: USPSData
}

struct Metadata: Codable {
    let business: Bool
    let poBox: Bool
}
