//
//  SectionViewHeader.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/15/23.
//

import Foundation
import SwiftUI

struct SectionHeaderView: View {
    var title: String
    var action: () -> Void

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: action) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}
