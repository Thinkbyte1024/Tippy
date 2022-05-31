import SwiftUI

struct IntroView: View {
    @Environment(\.dismiss) var dismissIntro

    var body: some View {
        ZStack {
            Color.cyan
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 16) {
                Spacer()

                Text("Hello, and welcome to Tippy!")
                    .font(.title)
                Text("Tippy is a simple tip calculator app created by Muhammad Aditya P D\nTo get started, tap \"Add a tip\" button below and add your tip.")
                    .multilineTextAlignment(.center)

                Spacer()

                Image("Tippy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 512, height: 512, alignment: .center)

                Spacer()

                Button("Let's get started") {
                    dismissIntro()
                }
                .controlSize(.large)
                .buttonStyle(BorderedProminentButtonStyle())

                Spacer()
            }
            .foregroundColor(.white)
            .interactiveDismissDisabled()
        }
    }
}
