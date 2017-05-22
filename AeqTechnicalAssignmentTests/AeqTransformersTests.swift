//
//  AeqTransformersTests.swift
//  AeqTechnicalAssignment
//
//  Created by asu on 2017-05-20.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import XCTest

class AeqTransformersTests: XCTestCase {
  
    // str int spe end rnk cou fir ski
    let bumblebee  = "Bumblebee, A, 5,5,5,5,5,10,5,5"
    let jazz       = "Jazz, A, 8,8,8,8,5,8,8,8"
    let ironhide   = "Ironhide, A, 9,9,5,9,9,9,5,9"
    let bluestreak = "Bluestreak, A, 6,6,7,9,5,2,9,7"
    let optimus    = "Optimus Prime, A, 10,10,10,10,10,10,10,10"
    
    let soundwave  = "Soundwave, D, 8,9,2,6,7,5,6,10"
    let shockwave  = "Shockwave, D, 8,9,3,8,9,9,9,10"
    let skywarp    = "Skywarp, D, 8,9,9,7,7,5,8,8"
    let starscream = "Starscream, D, 8,1,9,8,9,5,9,8"
    let predaking  = "Predaking, D, 10,10,10,10,10,10,10,10"
  
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTeamCreation() {
      var teams: (autobots:[Transformer], decepticons:[Transformer])
      
      let emptyTeams = [String]()
      teams = Transformer.createTeams(from: emptyTeams)
      XCTAssertEqual(teams.autobots.count, emptyTeams.count)
      XCTAssertEqual(teams.decepticons.count, emptyTeams.count)
      
      let onlyAutobots = [bumblebee, jazz, ironhide, bluestreak, optimus]
      teams = Transformer.createTeams(from: onlyAutobots)
      XCTAssertEqual(teams.autobots.count, onlyAutobots.count)
      XCTAssertEqual(teams.decepticons.count, 0)
      
      let onlyDecepticons = [soundwave, shockwave, skywarp, starscream, predaking]
      teams = Transformer.createTeams(from: onlyDecepticons)
      XCTAssertEqual(teams.autobots.count, 0)
      XCTAssertEqual(teams.decepticons.count, onlyDecepticons.count)
      
      let missingStats = "Someone, D, 1,2,3,4,5"
      let missingName = "A, 8,8,8,8,8,8,8,8"
      let missingType = "Someone, 8,8,8,8,8,8,8,8"
      let missingEverything = ""
      let invalidStats = "Someone, A, 8,Foo,8,8,Bar,8,8,8"
      
      teams = Transformer.createTeams(from: [bumblebee, missingName, shockwave])
      XCTAssertEqual(teams.autobots.count, 1)
      XCTAssertEqual(teams.decepticons.count, 1)
      
      teams = Transformer.createTeams(from: [bumblebee, missingType, shockwave])
      XCTAssertEqual(teams.autobots.count, 1)
      XCTAssertEqual(teams.decepticons.count, 1)
      
      teams = Transformer.createTeams(from: [bumblebee, missingStats, shockwave])
      XCTAssertEqual(teams.autobots.count, 1)
      XCTAssertEqual(teams.decepticons.count, 1)
      
      teams = Transformer.createTeams(from: [bumblebee, invalidStats, shockwave])
      XCTAssertEqual(teams.autobots.count, 1)
      XCTAssertEqual(teams.decepticons.count, 1)
      
      teams = Transformer.createTeams(from: [bumblebee, missingEverything, shockwave])
      XCTAssertEqual(teams.autobots.count, 1)
      XCTAssertEqual(teams.decepticons.count, 1)
      
    }
  
    func testNumberOfMatches() {
      let noTeams = Transformer.createTeams(from: [])
      var result = Transformer.fight(autobots: noTeams.autobots, decepticons: noTeams.decepticons)
      XCTAssertEqual(result.numberOfMatches, 0)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 0)
      
      let singleFighter = Transformer.createTeams(from: [ironhide])
      result = Transformer.fight(autobots: singleFighter.autobots, decepticons: singleFighter.decepticons)
      XCTAssertEqual(result.numberOfMatches, 0)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 0)
      
      let singleMatch = Transformer.createTeams(from: [ironhide, shockwave])
      result = Transformer.fight(autobots: singleMatch.autobots, decepticons: singleMatch.decepticons)
      XCTAssertEqual(result.numberOfMatches, 1)

      let moreAutobots = Transformer.createTeams(from: [ironhide, shockwave, bumblebee])
      result = Transformer.fight(autobots: moreAutobots.autobots, decepticons: moreAutobots.decepticons)
      XCTAssertEqual(result.numberOfMatches, 1)
      
      let moreDecepticons = Transformer.createTeams(from: [ironhide, shockwave, starscream])
      result = Transformer.fight(autobots: moreDecepticons.autobots, decepticons: moreDecepticons.decepticons)
      XCTAssertEqual(result.numberOfMatches, 1)

    }
  
    func testFightResults() {

      let courageWin = Transformer.createTeams(from: ["Winner,D,9,1,1,1,1,9,1,1", "Loser,A,1,9,9,9,9,1,9,9"])
      var result = Transformer.fight(autobots: courageWin.autobots, decepticons: courageWin.decepticons)
      XCTAssertEqual(result.numberOfMatches, 1)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 1)
      
      let skillWin = Transformer.createTeams(from: ["Winner,D,5,1,1,1,1,5,1,9", "Loser,A,5,9,9,9,9,5,9,1"])
      result = Transformer.fight(autobots: skillWin.autobots, decepticons: skillWin.decepticons)
      XCTAssertEqual(result.numberOfMatches, 1)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 1)
      
      let tie = Transformer.createTeams(from: ["Winner,D,5,5,5,5,5,5,5,5", "Loser,A,5,5,5,5,5,5,5,5"])
      result = Transformer.fight(autobots: tie.autobots, decepticons: tie.decepticons)
      XCTAssertEqual(result.numberOfMatches, 1)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 0)
      
      let overallWin = Transformer.createTeams(from: ["Winner,D,6,6,6,6,6,6,6,6", "Loser,A,5,5,5,5,5,5,5,5"])
      result = Transformer.fight(autobots: overallWin.autobots, decepticons: overallWin.decepticons)
      XCTAssertEqual(result.numberOfMatches, 1)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 1)

      let optimusWins = Transformer.createTeams(from: [optimus, shockwave, starscream, optimus])
      result = Transformer.fight(autobots: optimusWins.autobots, decepticons: optimusWins.decepticons)
      XCTAssertEqual(result.numberOfMatches, 2)
      XCTAssertEqual(result.autobotWinners.count, 2)
      XCTAssertEqual(result.decepticonWinners.count, 0)

      let predakingWins = Transformer.createTeams(from: [predaking, jazz, ironhide, predaking])
      result = Transformer.fight(autobots: predakingWins.autobots, decepticons: predakingWins.decepticons)
      XCTAssertEqual(result.numberOfMatches, 2)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 2)

      let leadersBeatAll = Transformer.createTeams(from: [predaking, "Loser1,A,99,99,99,99,1,99,99,99", optimus, "Loser2,D,99,99,99,99,11,99,99,99"])
      result = Transformer.fight(autobots: leadersBeatAll.autobots, decepticons: leadersBeatAll.decepticons)
      XCTAssertEqual(result.numberOfMatches, 2)
      XCTAssertEqual(result.autobotWinners.count, 1)
      XCTAssertEqual(result.autobotWinners[0].name, TransformerType.from("A")?.leaderName)
      XCTAssertEqual(result.decepticonWinners.count, 1)
      XCTAssertEqual(result.decepticonWinners[0].name, TransformerType.from("D")?.leaderName)

      let leadersAnnihilate = Transformer.createTeams(from: [predaking, optimus, shockwave, ironhide, starscream, bluestreak])
      result = Transformer.fight(autobots: leadersAnnihilate.autobots, decepticons: leadersAnnihilate.decepticons)
      XCTAssertEqual(result.numberOfMatches, 3)
      XCTAssertEqual(result.autobotWinners.count, 0)
      XCTAssertEqual(result.decepticonWinners.count, 0)

  }
  
}
