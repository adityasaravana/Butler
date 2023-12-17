//
//  ChangelogView.swift
//  Butler
//
//  Created by Aditya Saravana on 7/20/23.
//

import SwiftUI

struct ChangelogView: View {
    var body: some View {
        ScrollView {
            Text(Changelog.changelog).padding()
        }
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
    }
}
