//
//  CommonUI.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search symptoms / specialities", text: $searchText)
                .padding(8)
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct OfferCard: View {
    let offer: Offer

    var body: some View {
        Link(destination: URL(string: offer.url)!) { // Wrap the card content in a Link
            VStack {
                Text(offer.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(offer.color)
            .cornerRadius(10)
        }
    }
}


struct ServiceButton: View {
    let title: String
    let subtitle: String
    let color: Color
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.title) // Adjust icon size if needed
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(color)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

struct BestOffersView: View {
    let offers = [
        Offer(title: "Discount on Medicines", color: .green, url: "https://economictimes.indiatimes.com/industry/healthcare/biotech/pharmaceuticals/medplus-to-sell-over-500-off-patent-drugs-at-huge-discounts/articleshow/101162437.cms"),
        Offer(title: "Free Health Checkup", color: .blue, url: "https://www.nivabupa.com/health-insurance-articles/how-to-get-free-medical-checkups-under-your-health-insurance-policy.html"),
        Offer(title: "50% off on Dental Care", color: .purple, url: "https://www.newmouth.com/savings-plans/"),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(offers) { offer in
                    OfferCard(offer: offer)
                        .frame(width: 180, height: 90)
                }
            }
        }
    }
}


struct FeaturedServicesGrid: View {
    @StateObject private var viewModel = SpecializationViewModel()

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    let imageNames = [
        "dental-care", "facial-treatment-2", "mental-health", "mother", "neuron",
        "new-born", "sore-throat", "stethoscope-medical-tool", "mental-health", "mother", "neuron",
        "new-born", "sore-throat"
    ]

    var body: some View {
        ScrollView {
            LazyHGrid(rows: columns, spacing: 16) {
                if let specializations = viewModel.services["Specializations"] {
                    ForEach(Array(specializations.enumerated()), id: \.element.id) { index, service in
                        let imageName = imageNames[index % imageNames.count]
                        ServiceIcon(name: service.commonNames, commonNames: service.commonNames, imageName: imageName, specializationId: service.id)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 1)
            .foregroundColor(.black)
            .font(.headline)
            .onAppear {
                viewModel.fetchSpecializations()
            }
        }
    }
}

struct Doctor: Codable, Identifiable, Hashable, Equatable{
    let id: String
    let firstName: String
    let lastName: String
    let dob: String
    let gender: String
    let email: String
    let phone: String
    let state: String
    let city: String
    let pincode: String
    let address: String
    let experience: Int
    let specialization: SpecializationDetail

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case dob
        case gender
        case email
        case phone
        case state
        case city
        case pincode
        case address
        case experience
        case specialization
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
      }
    
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        return lhs.id == rhs.id
      }
}



struct SpecializationDetail: Codable {
    let id: String
    let specializationName: String
    let commonNames: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case specializationName
        case commonNames
    }
}

struct ServiceIcon: View {
    let name: String
    let commonNames: String
    let imageName: String
    let specializationId: String

    var body: some View {
        NavigationLink(destination: DoctorListView(specializationId: specializationId, commonNames: commonNames)) { // Pass both specializationId and commonNames
            VStack(spacing: 0) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 45)

                Text(name)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .padding(.top, 0)
            }
            .frame(width: UIScreen.main.bounds.width / 4 - 24, height: 100)
            .background(Color(.white))
            .cornerRadius(10)
        }
    }
}
