//
//  ConsultationOptionsCard.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

// MARK: - ConsultationOptionCard

struct ConsultationOptionCard: View {
    let iconName: String
    let title: String
    let subtitle: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green)
                .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding(16)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding([.leading, .bottom, .trailing], 16)
                .padding(.top, 8)
            }
        }
        .frame(height: 150)
    }
}
