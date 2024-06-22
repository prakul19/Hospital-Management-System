//
//  BedsAvailibilityViewComponents.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct SegmentedControlView: View {
    @Binding var selectedIndex: Int
    let titles: [String]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<titles.count, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    Text(titles[index])
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedIndex == index ? Color.green : Color.gray.opacity(0.2))
                        .foregroundColor(selectedIndex == index ? .white : .black)
                }
            }
        }
        .frame(height: 40)
        .cornerRadius(10)
    }
}

struct BedRowView: View {
    let bed: String
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text(bed)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}
