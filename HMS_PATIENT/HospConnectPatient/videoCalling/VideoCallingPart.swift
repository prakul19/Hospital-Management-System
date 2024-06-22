//
//  VideoCallingPart.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//


import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

struct VideoCallApps: View {
    @ObservedObject var viewModel: CallViewModel
    private var client: StreamVideo

    private let apiKey: String = "mmhfdzb5evj2" // The API key can be found in the Credentials section
    private let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiTmF0YXNpX0RhYWxhIiwiaXNzIjoiaHR0cHM6Ly9wcm9udG8uZ2V0c3RyZWFtLmlvIiwic3ViIjoidXNlci9OYXRhc2lfRGFhbGEiLCJpYXQiOjE3MTgzNDAxMTcsImV4cCI6MTcxODk0NDkyMn0.z01Kajwxk__NNh3XtoUeN5T5lqem9oXPsg50iPGoxO0" // The Token can be found in the Credentials section
    private let userId: String = "Natasi_Daala" // The User Id can be found in the Credentials section
    private let callId: String = "Cl5jLAJ7xwDV" // The CallId can be found in the Credentials section

    init() {
        let user = User(
            id: userId,
            name: "Patient",
            imageURL: .init(string: "https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/a3911/martin-mitrevski.webp")
        )

        // Initialize Stream Video client
        self.client = StreamVideo(
            apiKey: apiKey,
            user: user,
            token: .init(stringLiteral: token)
        )

        self.viewModel = .init()
    }

    var body: some View {
        VStack {
            if viewModel.call != nil {
                CallContainer(viewFactory: DefaultViewFactory.shared, viewModel: viewModel)
            } else {
                Text("loading...")
            }
        }.onAppear {
            Task {
                guard viewModel.call == nil else { return }
                viewModel.joinCall(callType: .default, callId: callId)
            }
        }
    }
}



struct ParticipantsView: View {

    var call: Call
    var participants: [CallParticipant]
    var onChangeTrackVisibility: (CallParticipant?, Bool) -> Void

    var body: some View {
        GeometryReader { proxy in
            if !participants.isEmpty {
                ScrollView {
                    LazyVStack {
                        if participants.count == 1, let participant = participants.first {
                            makeCallParticipantView(participant, frame: proxy.frame(in: .global))
                                .frame(width: proxy.size.width, height: proxy.size.height)
                        } else {
                            ForEach(participants) { participant in
                                makeCallParticipantView(participant, frame: proxy.frame(in: .global))
                                    .frame(width: proxy.size.width, height: proxy.size.height / 2)
                            }
                        }
                    }
                }
            } else {
                Color.black
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    @ViewBuilder
    private func makeCallParticipantView(_ participant: CallParticipant, frame: CGRect) -> some View {
        VideoCallParticipantView(
            participant: participant,
            availableFrame: frame,
            contentMode: .scaleAspectFit,
            customData: [:],
            call: call
        )
        .onAppear { onChangeTrackVisibility(participant, true) }
        .onDisappear{ onChangeTrackVisibility(participant, false) }
    }
}

struct FloatingParticipantView: View {

    var participant: CallParticipant?
    var size: CGSize = .init(width: 120, height: 120)

    var body: some View {
        if let participant = participant {
            VStack {
                HStack {
                    Spacer()

                    VideoRendererView(id: participant.id, size: size) { videoRenderer in
                        videoRenderer.handleViewRendering(for: participant, onTrackSizeUpdate: { _, _ in })
                    }
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer()
            }
            .padding()
        }
    }
}
