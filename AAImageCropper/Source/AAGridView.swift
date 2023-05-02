//
//  AAGridView.swift
//  AAImageCropper
//
//  Created by Muhammad Azher on 24/04/2023.
//

import SwiftUI

struct AAGridView: View {
    
    func getGridView() -> some View {
        Group() {
            ZStack {
                VStack {
                    Spacer()
                    getDivider()
                    Spacer()
                    getDivider()
                    Spacer()
                }
                HStack {
                    Spacer()
                    getHeightDivider()
                    Spacer()
                    getHeightDivider()
                    Spacer()
                }
            }
        }
    }
    
    var body: some View {
        getGridView()
    }
    func getDivider() -> some View {
        Divider()
            .frame(height: 1)
            .background(Color.gray)
    }
    func getHeightDivider() -> some View {
        Divider()
            .frame(width: 1)
            .background(Color.gray)
    }
}

struct AAGridView_Previews: PreviewProvider {
    static var previews: some View {
        AAGridView()
    }
}
