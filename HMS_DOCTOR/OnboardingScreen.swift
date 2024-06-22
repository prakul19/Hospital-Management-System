import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            // Logo
            HStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                Spacer()
            }
            .padding(.leading, 20) // Padding for the logo
            
            // Welcome text
            Text("Welcome to")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.black)
                .padding(.leading, 20) // Padding for the welcome text

            // Hosp Connect text
            Text("Hosp Connect")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.green)
                .padding(.leading, 20) // Padding for Hosp Connect text

            // Transforming Healthcare text
            Text("Transforming Healthcare with Our Hospital Management System")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.top, 10)
                .padding(.bottom, 30)
                .padding(.leading, 20) // Padding for the transforming healthcare text

            // Features list
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Book Appointments")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Easy booking, rescheduling, and cancellation of appointments.")
                            .font(.body)
                    }
                }

                HStack(alignment: .top) {
                    Image(systemName: "phone")
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Contact Healthcare Providers")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Secure messaging with doctors and hospital staff.")
                            .font(.body)
                    }
                }

                HStack(alignment: .top) {
                    Image(systemName: "heart")
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Health and Wellness Tools")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Personal health trackers for monitoring vital signs and fitness.")
                            .font(.body)
                    }
                }
            }
            .padding(.leading, 20) // Padding for the features list

            Spacer()

            // Continue button
            Button(action: {
               hasSeenOnboarding = true
            }) {
                Text("Continue")
                    .fontWeight(.bold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            Spacer()
        }
        .padding(.trailing, 20) // Apply trailing padding to align everything
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
