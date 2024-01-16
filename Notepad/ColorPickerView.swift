//
//  ColorPickerView.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 14/01/24.
//

import SwiftUI

import SwiftUI

struct ColorPickerView: View {
    
    let colors = [Color.red, Color.orange, Color.green, Color.blue, Color.purple]
    @Binding var selectedColor: Color
//    @State private var bgColor =
//            Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    var body: some View {
        HStack {
//            ColorPicker("Color",selection: $bgColor)
            
            ForEach(colors, id: \.self) { color in
            
                Image(systemName: selectedColor == color ? Constants.Icons.recordCircleFill : Constants.Icons.circleFill)
                    .foregroundColor(color)
                    .font(.system(size: 16))
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

struct ColorListView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.blue))
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.blue))
}
