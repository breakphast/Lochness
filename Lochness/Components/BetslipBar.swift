//
//  BetslipBar.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/8/24.
//

import SwiftUI

struct BetslipBar: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY)) // bottom left
        path.addLine(to: CGPoint(x: 0, y: radius)) // top left
        path.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: 0)) // before top right corner
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: radius), radius: radius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // bottom right

        return path
    }
}
