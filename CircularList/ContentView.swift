//
//  ContentView.swift
//  CircularList
//
//  Created by Enrique Haro on 6/6/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        HStack {
            VStack {
                Button(action: {
                    viewModel.toggle()
                }, label: {
                    Text("\(viewModel.direction)".uppercased().prefix(1))
                        .font(.system(size: 32))
                        .padding(10.0)
                })
                Spacer()
            }
            VStack {
                Spacer()
                    .frame(height: 60.0)
                CircularTabView(views: viewModel.views,
                                index: $viewModel.index,
                                scrollDirection: viewModel.direction)
            }
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 150.0)
    }
}

class ViewModel: ObservableObject {
    let array1 = ["A", "B", "C", "D"]
    let array2 = ["X", "Y", "Z"]

    var views: [CellView]

    @Published var index = 0
    @Published var direction: ScrollDirection = .horizontal

    init() {
        views = array1.map { CellView(text: $0, color: .yellow) }
    }

    func toggle() {
        if direction == .vertical {
            direction = .horizontal
            views = array1.map { CellView(text: $0, color: .yellow) }
        } else {
            direction = .vertical
            views = array2.map { CellView(text: $0, color: .cyan) }
        }
    }
}

extension DispatchQueue {
    func asyncAfter(seconds: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            closure()
        }
    }
}
