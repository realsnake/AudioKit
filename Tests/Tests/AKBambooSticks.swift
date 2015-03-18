//
//  main.swift
//  AudioKit
//
//  Created by Nick Arner and Aurelius Prochazka on 12/26/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

import Foundation

let testDuration: Float = 10.0

class Instrument : AKInstrument {

    override init() {
        super.init()

        let note = BambooNote()
        let bambooSticks = AKBambooSticks()
        bambooSticks.count = note.count
        bambooSticks.mainResonantFrequency = note.mainResonantFrequency

        enableParameterLog(
            "Count = ",
            parameter: bambooSticks.count,
            timeInterval:2
        )

        enableParameterLog(
            "Main Resonant Frequency = ",
            parameter: bambooSticks.mainResonantFrequency,
            timeInterval:2
        )

        setAudioOutput(bambooSticks)
    }
}

class BambooNote: AKNote {
    var count = AKNoteProperty()
    var mainResonantFrequency = AKNoteProperty()

    override init() {
        super.init()
        addProperty(count)
        addProperty(mainResonantFrequency)
    }

    convenience init(count: Int, mainResonantFrequency: Float) {
        self.init()
        self.count.value = Float(count)
        self.mainResonantFrequency.value = mainResonantFrequency
    }
}

AKOrchestra.testForDuration(testDuration)

let instrument = Instrument()
AKOrchestra.addInstrument(instrument)

let phrase = AKPhrase()

for i in 1...10 {
    let note = BambooNote(count: i, mainResonantFrequency: 1000+Float(i)*300)
    note.duration.value = 1.0
    phrase.addNote(note, atTime: Float(i-1))
}

instrument.playPhrase(phrase)

let manager = AKManager.sharedManager()
while(manager.isRunning) {} //do nothing
println("Test complete!")
