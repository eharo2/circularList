//
//  CircularTabView+Touch.swift
//  CircularList
//
//  Created by Enrique Haro on 6/6/25.
//

import SwiftUI

extension CircularTabView {

    func touchEnded(_ touch: DragGesture.Value) {
        guard !isAnimating else { return }
        previousPoint = .zero
        let center = CGPoint(x: size.width/2.0, y: size.height/2.0)
        if scrollDirection.horizontal {
            let leftEdge = currentPoint.x - center.x
            let rightEdge = currentPoint.x + center.x

            if leftEdge > .zero && leftEdge < center.x {
                moveTo(.center, animated: true)
                return
            }
            if rightEdge > center.x && rightEdge < size.width {
                moveTo(.center, animated: true)
                return
            }
            if leftEdge > center.x {
                moveTo(.next, animated: true)
                updateViews(with: previousIndex)
                return
            }
            if rightEdge < center.x {
                moveTo(.previous, animated: true)
                updateViews(with: nextIndex)
                return
            }
        } else {
            let topEdge = currentPoint.y - center.y
            let bottomEdge = currentPoint.y + center.y

            if topEdge > .zero && topEdge < center.y {
                moveTo(.center, animated: true)
                return
            }
            if bottomEdge > center.y && bottomEdge < size.height {
                moveTo(.center, animated: true)
                return
            }
            if topEdge > center.y {
                moveTo(.next, animated: true)
                updateViews(with: previousIndex)
                return
            }
            if bottomEdge < center.y {
                moveTo(.previous, animated: true)
                updateViews(with: nextIndex)
                return
            }
        }
    }

    func updateViews(with newIndex: Int) {
        isAnimating = true
        DispatchQueue.main.asyncAfter(seconds: 0.1) {
            index = newIndex
            moveTo(.center)
            isAnimating = false
        }
    }

    func touchChanged(_ touch: DragGesture.Value) {
        if previousPoint != .zero {
            if scrollDirection.horizontal {
                currentPoint.x += touch.location.x - previousPoint.x  // DeltaX
            } else {
                currentPoint.y += touch.location.y - previousPoint.y  // DeltaY
            }
        }
        previousPoint = touch.location
    }
}
