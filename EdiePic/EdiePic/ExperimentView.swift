//
//  ExperimentView.swift
//  EdiePic
//
//  Created by G Abhisek on 25/08/20.
//  Copyright © 2020 G Abhisek. All rights reserved.
//

import SwiftUI

struct ExperimentView: View {
    @State var bodyText: String = "Hello swift"
    private var mutableBodyText: String = "Hello swift" {
        didSet {
            bodyText = mutableBodyText
        }
    }
    
    init() {
        triggerTextUpdateViaDidSet()
    }
    
    var body: some View {
        Text(bodyText)
                .onAppear(perform: triggerTextUpdate)
    }
    
    private mutating func triggerTextUpdateViaDidSet() {
        var result =  self
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            result.mutableBodyText = "Hello I am future swift"
        }
        self = result
    }
    
    private func triggerTextUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            bodyText = "Hello I am future swift"
        }
    }
}

struct ExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentView()
    }
}
