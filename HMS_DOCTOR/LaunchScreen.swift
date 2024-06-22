import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            if isActive {
                WelcomeScreen()
            } else {
                VStack {
                    Spacer()
                    Image("Logo") // Replace with your logo
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("Hosp Connect")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

