//
//  CircularTabView.swift
//  CircularList
//
//  Created by Enrique Haro on 6/6/25.
//

import SwiftUI

struct CircularTabView<T: View>: View {
    var views: [T]
    @Binding var index: Int
    let scrollDirection: ScrollDirection

    @State internal var size: CGSize = .zero
    @State internal var previousPoint: CGPoint = .zero
    @State internal var currentPoint: CGPoint = .zero
    @State internal var isAnimating: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                viewForPosition(.previous)
                viewForPosition(.center)
                    .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                        .onEnded { touchEnded($0) }
                        .onChanged { touchChanged($0) }
                    )
                viewForPosition(.next)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .padding(scrollDirection.horizontal ? 1.0 : 2.0)
            .onAppear {
                size = CGSize(width: geometry.size.width - 2.0, height: geometry.size.height - 2.0)
                currentPoint = CGPoint(x: size.width/2.0, y: size.height/2.0)
            }
        }
    }

    func viewForPosition(_ position: Position) -> some View {
        switch position {
        case .previous: viewFor(previousIndex).position(previousPosition)
        case .center: viewFor(index).position(centerPosition)
        case .next: viewFor(nextIndex).position(nextPosition)
        }
    }

    @ViewBuilder func viewFor(_ index: Int) -> some View {
        if index >= 0 && index < views.count {
            views[index]
        } else {
            EmptyView()
        }
    }
}

// MARK: - Views Position
extension CircularTabView {
    var previousPosition: CGPoint {
        if scrollDirection.horizontal {
            CGPoint(x: currentPoint.x - size.width, y: size.height/2.0)
        } else {
            CGPoint(x: size.width/2.0, y: currentPoint.y - size.height)
        }
    }

    var centerPosition: CGPoint {
        if scrollDirection.horizontal {
            CGPoint(x: currentPoint.x, y: size.height/2.0)
        } else {
            CGPoint(x: size.width/2.0, y: currentPoint.y)
        }
    }

    var nextPosition: CGPoint {
        if scrollDirection.horizontal {
            CGPoint(x: currentPoint.x + size.width, y: size.height/2.0)
        } else {
            CGPoint(x: size.width/2.0, y: currentPoint.y + size.height)
        }
    }

    var previousIndex: Int { index > 0 ? index - 1 : views.count - 1 }
    var nextIndex: Int { index < views.count - 1 ? index + 1 : 0 }
}

// MARK: - Views Animation
extension CircularTabView {
    func moveTo(_ position: Position, animated: Bool = false) {
        if scrollDirection.horizontal {
            let updatedX = size.width * position.factor + position.offset
            if animated {
                withAnimation(.spring()) {
                    currentPoint.x = updatedX
                }
            } else {
                currentPoint.x = updatedX
            }
        } else {
            let updatedY = size.height * position.factor + position.offset
            if animated {
                withAnimation(.spring()) {
                    currentPoint.y = updatedY
                }
            } else {
                currentPoint.y = updatedY
            }
        }
    }
}

// MARK: - enums
extension CircularTabView {
    enum Position {
        case previous
        case center
        case next

        var factor: CGFloat {
            switch self {
            case .previous: -0.5
            case .center: 0.5
            case .next: 1.5
            }
        }

        var offset: CGFloat {
            switch self {
            case .previous: 2.0
            case .center: 0.0
            case .next: 1.0
            }
        }
    }
}

enum ScrollDirection {
    case horizontal, vertical

    var horizontal: Bool {
        self == .horizontal
    }
}
