import SwiftUI

struct BedAvailabilityView: View {
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    @State private var beds: [Bed] = []
    @State private var showAddBedSheet = false
    @State private var showAlert = false
    @State private var bedToDelete: Bed?
    @State private var isLoading = true
    @State private var isDeleting = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    SegmentedControlView(selectedIndex: $selectedTab, titles: ["Available", "Not available"])
                        .padding()

                    HStack {
                        Text(selectedTab == 0 ? "Available : \(availableBedsCount)" : "Not Available : \(notAvailableBedsCount)")
                            .bold()
                        Spacer()
                    }
                    .padding()

                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(beds.filter { selectedTab == 0 ? $0.status == "available" : $0.status == "occupied" }, id: \.self) { bed in
                                BedRowView(bed: bed.bedNumber, onDelete: {
                                    bedToDelete = bed
                                    showAlert = true
                                })
                            }
                        }
                        .padding()
                    }
                }
                .navigationBarTitle("Beds", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.green)
                                .bold()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddBedSheet = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                        }
                    }
                }
                .sheet(isPresented: $showAddBedSheet) {
                    AddBedSheet(showAddBedSheet: $showAddBedSheet)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Delete Bed"),
                        message: Text("Are you sure you want to delete this bed?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let bedToDelete = bedToDelete {
                                deleteBed(bed: bedToDelete)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .onAppear {
                    fetchBeds()
                }

                // Overlay loader conditionally
                if isLoading || isDeleting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0, anchor: .center)
                        .padding()
                        .background(Color.white.opacity(0.7)) // Semi-transparent background
                        .cornerRadius(10)
                        .shadow(radius: 10) // Add shadow for better visibility
                        .padding() // Padding to ensure it's not on the edge
                }
            }
            .allowsHitTesting(!isLoading && !isDeleting) // Enable/disable interaction based on loading state
        }
        .navigationBarBackButtonHidden(true)
    }

    var availableBedsCount: Int {
        beds.filter { $0.status == "available" }.count
    }

    var notAvailableBedsCount: Int {
        beds.filter { $0.status == "occupied" }.count
    }

    @MainActor func fetchBeds() {
        guard let token = AuthViewModel().currentUserToken else {
            print("Token is not available")
            return
        }

        // Define the URL based on the selected segment
        let urlString: String
        if selectedTab == 0 {
            urlString = "https://apihosp.squaash.xyz/api/v1/hospitalAdmin/beds/get?status=available"
        } else {
            urlString = "https://apihosp.squaash.xyz/api/v1/hospitalAdmin/beds/get?status=occupied"
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(BedResponse.self, from: data)

                DispatchQueue.main.async {
                    self.beds = decodedResponse.beds
                    self.isLoading = false
                }
            } catch {
                print("Error decoding data: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }

    @MainActor func deleteBed(bed: Bed) {
        isDeleting = true
        guard let token = AuthViewModel().currentUserToken else {
            print("Token is not available")
            return
        }

        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/hospitalAdmin/beds/delete") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = ["bedIds": [bed.id]]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error deleting bed: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.isDeleting = false
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(DeleteResponse.self, from: data)
                if response.success {
                    DispatchQueue.main.async {
                        self.beds.removeAll { $0.id == bed.id }
                        self.isDeleting = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isDeleting = false
                    }
                }
            } catch {
                print("Error decoding delete response: \(error)")
                DispatchQueue.main.async {
                    self.isDeleting = false
                }
            }
        }.resume()
    }
}

struct BedAvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        BedAvailabilityView()
    }
}
