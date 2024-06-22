//
//  FAQView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        List {
            Section(header: Text("General Questions")) {
                Text("How do I create an account?")
                Text("How do I reset my password?")
            }
            Section(header: Text("Appointments")) {
                Text("How do I book an appointment?")
                Text("How do I cancel an appointment?")
            }
        }
        .navigationTitle("FAQs")
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FAQView()
        }
    }
}

