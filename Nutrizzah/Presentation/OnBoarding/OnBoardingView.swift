//
//  on-boarding.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct on_boarding: View {
    var body: some View {
        VStack{
            Circle()
                .frame(width: 126, height: 126)
                .foregroundColor(.blue)
            Text("Nutrizzah")
                .font(.custom("PPEditorialNew-Ultrabold", size: 48))
            Text("Catatan Nutrisi Harianmu Azzah")
                .font(Font.system(size: 22))
                .opacity(0.6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.gradien1, .gradien2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    on_boarding()
}
