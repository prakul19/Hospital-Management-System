
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn {
            MainView(
                isLoggedIn: $viewModel.isLoggedIn,
                doctorId: $viewModel.doctorId,
                password: $viewModel.password,
                appointments: $viewModel.appointments,
                viewModel: viewModel
            )
        } else {
            VStack {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                Text("Hosp Connect")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                VStack(spacing: 20) {
                    TextField("Doctor ID", text: $viewModel.doctorId)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 32)
                
                HStack {
                    Button(action: {
                        // Action for Forgot Password
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Action for Don't have an account?
                    }) {
                        Text("Don’t have an account?")
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 8)
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 8)
                }
                
                Button(action: {
                    viewModel.login()
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
}
