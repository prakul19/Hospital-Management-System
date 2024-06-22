//import SwiftUI
//
//struct AvailabilityView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedDateIndex = 2
//    @State private var selectedTimes: [String] = []
//
//    let dates = [
//        ("Tue", "04"),
//        ("Wed", "05"),
//        ("Thu", "06"),
//        ("Fri", "07")
//    ]
//
//    let times = [
//        "09:00-09:45 am",
//        "10:00-10:45 am",
//        "11:00-11:45 am",
//        "12:00-12:45 pm",
//        "02:00-02:45 pm",
//        "03:00-03:45 pm"
//    ]
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    Button("Cancel") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    Spacer()
//                    Text("Availability")
//                        .font(.headline)
//                    Spacer()
//                    Button("Done") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//                .padding()
//
//                HStack {
//                    Text("Thu, 06 June")
//                        .font(.title2)
//                        .padding()
//                    Spacer()
//                }
//
//                HStack {
//                    ForEach(0..<dates.count, id: \.self) { index in
//                        VStack {
//                            Text(dates[index].0)
//                                .font(.headline)
//                                .foregroundColor(index == selectedDateIndex ? .white : .black)
//                            Text(dates[index].1)
//                                .font(.title)
//                                .foregroundColor(index == selectedDateIndex ? .white : .black)
//                        }
//                        .frame(width: 80, height: 80)
//                        .background(index == selectedDateIndex ? Color.gray : Color(.systemGray6))
//                        .cornerRadius(10)
//                        .onTapGesture {
//                            selectedDateIndex = index
//                        }
//                    }
//                }
//                .padding()
//
//                VStack(spacing: 10) {
//                    ForEach(0..<times.count / 2) { rowIndex in
//                        HStack {
//                            ForEach(0..<2) { columnIndex in
//                                let timeIndex = rowIndex * 2 + columnIndex
//                                if timeIndex < times.count {
//                                    Text(times[timeIndex])
//                                        .foregroundColor(selectedTimes.contains(times[timeIndex]) ? .white : .black)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(selectedTimes.contains(times[timeIndex]) ? Color.gray : Color(.systemGray6))
//                                        .cornerRadius(10)
//                                        .onTapGesture {
//                                            let selectedTime = times[timeIndex]
//                                            if selectedTimes.contains(selectedTime) {
//                                                selectedTimes.removeAll { $0 == selectedTime }
//                                            } else {
//                                                selectedTimes.append(selectedTime)
//                                            }
//                                        }
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding()
//
//                Spacer()
//            }
//        }
//    }
//}
//
//struct AvailabilityView_Previews: PreviewProvider {
//    static var previews: some View {
//        AvailabilityView()
//    }
//}


import SwiftUI

struct Slot {
    var day: String
    var date: Date
    var times: [TimeSlot]
}

struct TimeSlot: Identifiable {
    var id = UUID()
    var time: String
    var limit: Int
    var booked: Int
    var isActive: Bool
}

struct AvailabilityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDateIndex = 0
    @State private var futureDates: [(String, String, Date, Bool)] = [] // Added Bool for weekend
    @State private var selectedSlots: [Slot] = []
    @EnvironmentObject var viewModel : AppViewModel
    
    let times = [
        "9-10", "10-11", "11-12", "12-1", "1-2", "2-3"
    ]
    
    let numberOfDaysToDisplay = 5 // Change this as needed
    @State private var selectedWeekStart = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("Availability")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        saveAvailability()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<futureDates.count, id: \.self) { index in
                            VStack {
                                Text(futureDates[index].0)
                                    .font(.headline)
                                    .foregroundColor(index == selectedDateIndex ? .white : (futureDates[index].3 ? .white : .black)) // Set text color based on background
                                Text(futureDates[index].1)
                                    .font(.title)
                                    .foregroundColor(index == selectedDateIndex ? .white : (futureDates[index].3 ? .white : .black)) // Set text color based on background
                            }
                            .frame(width: 80, height: 80)
                            .background(
                                futureDates[index].3 ? Color.gray : (index == selectedDateIndex ? Color.green : Color(.white))
                            )
                            .cornerRadius(10)
                            .padding(.horizontal, 4)
                            .onTapGesture {
                                if !futureDates[index].3 {
                                    selectedDateIndex = index
                                }
                            }
                        }
                    }
                }
                
                
                .padding()
                
                VStack(spacing: 10) {
                    ForEach(0..<times.count / 2 + times.count % 2, id: \.self) { rowIndex in
                        HStack(spacing: 10) {
                            ForEach(0..<2, id: \.self) { columnIndex in
                                let index = rowIndex * 2 + columnIndex
                                if index < times.count {
                                    let time = times[index]
                                    let displayTime = formatDisplayTime(time)
                                    Button(action: {
                                        toggleTimeSlot(for: time, dayIndex: selectedDateIndex)
                                    }) {
                                        HStack {
                                            Text(displayTime)
                                                .foregroundColor(isTimeSlotSelected(for: time, dayIndex: selectedDateIndex) ? .white : .black)
                                            Spacer()
                                        }
                                        .padding()
                                        .background(isTimeSlotSelected(for: time, dayIndex: selectedDateIndex) ? Color.green : Color(.white))
                                        .cornerRadius(10)
                                        .disabled(isWeekendSelected(for: selectedDateIndex))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
        }
        .onAppear {
            generateFutureDates(startingFrom: selectedWeekStart)
            
        }
    }
    
    func formatDisplayTime(_ time: String) -> String {
        let components = time.components(separatedBy: "-")
        guard let start = components.first, let end = components.last else {
            return time
        }
        let startTime = convertToAMPM(start)
        let endTime = convertToAMPM(end)
        return "\(startTime) - \(endTime)"
    }
    
    func convertToAMPM(_ time: String) -> String {
        guard let hour = Int(time) else {
            return time
        }
        if hour == 12 {
            return "12pm"
        } else if hour > 12 {
            return "\(hour - 12)pm"
        } else if hour <= 3 {
            return "\(hour)pm"
        } else {
            return "\(hour)am"
        }
    }
    
    func generateFutureDates(startingFrom startDate: Date) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Full day name
        let dateFormatterShort = DateFormatter()
        dateFormatterShort.dateFormat = "E" // Abbreviated day name
        
        futureDates = (0..<numberOfDaysToDisplay).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: startDate)!
            let dayName = dateFormatter.string(from: date)
            let dayNameShort = dateFormatterShort.string(from: date)
            let dayNumber = Calendar.current.component(.day, from: date)
            let isWeekend = calendar.component(.weekday, from: date) == 1 || calendar.component(.weekday, from: date) == 7 // Check if the day is Saturday or Sunday
            let slot = Slot(day: dayName, date: date, times: [])
            if !selectedSlots.contains(where: { $0.day == dayName }) {
                selectedSlots.append(slot)
            }
            return (dayNameShort, String(format: "%02d", dayNumber), date, isWeekend)
        }
    }
    
    func toggleTimeSlot(for timeSlot: String, dayIndex: Int) {
        if let index = selectedSlots[dayIndex].times.firstIndex(where: { $0.time == timeSlot }) {
            selectedSlots[dayIndex].times.remove(at: index)
        } else {
            selectedSlots[dayIndex].times.append(TimeSlot(time: timeSlot, limit: 6, booked: 0, isActive: true))
        }
    }
    
    func isTimeSlotSelected(for timeSlot: String, dayIndex: Int) -> Bool {
        return selectedSlots[dayIndex].times.contains { $0.time == timeSlot }
    }
    
    func isWeekendSelected(for dayIndex: Int) -> Bool {
        let dayOfWeek = Calendar.current.component(.weekday, from: futureDates[dayIndex].2)
        return dayOfWeek == 1 || dayOfWeek == 7 // Sunday is 1, Saturday is 7
    }
    
    
    
    
    func saveAvailability() {
        let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/availability")!
        
        // Prepare the availability data
        print("ye token check \(viewModel.token)")
        guard let token = viewModel.token else {
            print("token is not present");
            return;
        }
        
        print("Adding availability \(token)")
        
        let availabilityData: [String: Any] = [
            "weekStart": ISO8601DateFormatter().string(from: selectedWeekStart),
            "slots": selectedSlots.map { slot in
                [
                    "day": slot.day,
                    "date": ISO8601DateFormatter().string(from: slot.date),
                    "times": slot.times.map { timeSlot in
                        [
                            "time": timeSlot.time,
                            "limit": timeSlot.limit,
                            "booked": timeSlot.booked,
                            "isActive": timeSlot.isActive
                        ]
                    }
                ]
            }
        ]
        
        // Convert data to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: availabilityData) else {
            print("Failed to serialize availability data.")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add bearer token
//        let bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjY5ZWRlNGQyOTZlYTU1ZTJlNDc5ZCIsImlhdCI6MTcxODAwMTUwNywiZXhwIjoxNzIwNTkzNTA3fQ.DMCe_ArYs0xmkZ09b9fQPB4vA_zSRkS2vbg7_5g1WrQ"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating availability: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response JSON: \(jsonString)")
                    }
                }
            }
        }.resume()
    }
}

struct AvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        AvailabilityView()
    }
}
