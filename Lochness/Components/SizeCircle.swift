//
//  LeagueSizeCircle.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct SizeCircle<Mode: SizeOptionRepresentable>: View {
    let sizeOption: Mode
    @Binding var selectedSize: Mode

    var body: some View {
        ZStack {
            Circle()
                .fill(selectedSize == sizeOption ? Color("main100") : .white)
                .stroke(Color("main700"), lineWidth: (selectedSize == sizeOption ? 4 : 2))
                .frame(width: 56)
            Text("\(sizeOption.displayValue)")
                .font(.caption)
                .fontWeight(.heavy)
                .foregroundColor(Color("main700"))
        }
        .onTapGesture {
            withAnimation {
                selectedSize = sizeOption
            }
        }
    }
}

struct GenericSizeSelector<SizeOption: SizeOptionRepresentable>: View {
    let sizes: [SizeOption]
    @Binding var selectedSize: SizeOption

    var body: some View {
        VStack(spacing: 16) {
            Text("Size")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Spacer()
                ForEach(sizes, id: \.self) { size in
                    SizeCircle(sizeOption: size, selectedSize: $selectedSize)
                }
            }
        }
    }
}
