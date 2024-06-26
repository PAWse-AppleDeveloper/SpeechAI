//
//  JournalS7.swift
//  SpeechAI
//
//  Created by Heical Chandra on 26/06/24.
//

import SwiftUI

struct JournalS7: View {
    var body: some View {
        TemplateJournal(number: 7, title: "In what ways is anxiety not a weakness?", isActive: 7, destination: JournalS8())
            .navigationBarBackButtonHidden(true)    }
}

#Preview {
    JournalS7()
}
