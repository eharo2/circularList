//
//  CellView.swift
//  CircularList
//
//  Created by Enrique Haro on 6/6/25.
//

import SwiftUI

struct CellView: View {
    let text: String
    let color: Color

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .cornerRadius(15.0)
            Rectangle()
                .foregroundColor(color)
                .cornerRadius(14.5)
                .padding(1.0)
            Text(text)
                .font(.system(size: 100.0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
