import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .padding(.horizontal, 40)
                    .padding(.top , 40)
                    .padding(.bottom , 5)
                  

                Text("Welcome to")
                    .font(.system(size: 40).weight(.heavy))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)

                Text("HospConnect")
                    .font(.system(size: 40).weight(.heavy))
                    .foregroundColor(Color.green)
                    .padding(.horizontal, 40)
                    .padding(.top, -35)
                    .padding(.bottom, 10)

                Text("Transforming Healthcare with Our Hospital Management System")
                    .font(.subheadline)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
            
            VStack(alignment: .leading, spacing: 18) {
                FeatureView(icon: "calendar", title: "Book Appointments", description: "Easy booking, rescheduling, and cancellation of appointments.")
                FeatureView(icon: "phone", title: "Contact Healthcare Providers", description: "Secure messaging with doctors and hospital staff.")
                FeatureView(icon: "heart", title: "Health and Wellness Tools", description: "Personal health trackers for monitoring vital signs and fitness.")
            }
            .padding(.horizontal, 20)

            Spacer()

            Button(action: {
                hasSeenOnboarding = true
            }) {
                Text("Continue")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)

            Spacer()
        }
    }
}

struct FeatureView: View {
    var icon: String
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(description)
                    .font(.body)
            }
        }
        .padding(.bottom, 10)
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
