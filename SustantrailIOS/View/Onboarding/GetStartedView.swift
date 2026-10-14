import SwiftUI

struct GetStartedView: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        ZStack {
            
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text(K.TextSustainTrail)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .opacity(0.73)
                
                Image(.startpagelogo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                StartingBottomSection(onClick: onGetStarted)
            }
            .padding(30)
        }
    }
}

private struct StartingBottomSection: View {
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text(K.textLoginViewGetStarted)
                .font(.Poppinsbold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color(hex: K.Color.green))
                .cornerRadius(15)
        }
    }
}

#Preview {
    GetStartedView { }
}
