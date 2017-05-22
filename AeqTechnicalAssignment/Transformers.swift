//
//  Transformers.swift
//  AeqTechnicalAssignment
//
//  Created by asu on 2017-05-19.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

enum TransformerType:String {
  case Autobot = "A"
  case Decepticon = "D"
  
  static func from(_ input:String) -> TransformerType?
  {
    switch input.trimmingCharacters(in: .whitespaces).uppercased() {
    case TransformerType.Autobot.rawValue:
      return .Autobot
    case TransformerType.Decepticon.rawValue:
      return .Decepticon
    default:
      return nil
    }
  }
  
  var leaderName: String
  {
    switch self {
      case .Autobot: return "Optimus Prime"
      case .Decepticon: return "Predaking"
    }
  }
  
  var fullTeamName:String
  {
    switch self {
      case .Autobot: return "Autobots"
      case .Decepticon: return "Decepticons"
    }
  }
}

class Transformer: CustomStringConvertible
{
  
  let type:TransformerType
  let name:String
  
  let strength: Int
  let intelligence: Int
  let speed: Int
  let endurance: Int
  let rank: Int
  let courage: Int
  let firepower: Int
  let skill: Int
  
  var overallRating: Int
  {
    return strength + intelligence + speed + endurance + firepower
  }
  
  var isTeamLeader:Bool
  {
    return name == type.leaderName
  }
  
  required init(_ type:TransformerType, name:String, strength:Int, intelligence:Int, speed:Int, endurance:Int, rank: Int, courage:Int, firepower:Int, skill:Int)
  {
    self.type = type
    self.name = name
    
    self.strength = strength
    self.intelligence = intelligence
    self.speed = speed
    self.endurance = endurance
    self.rank = rank
    self.courage = courage
    self.firepower = firepower
    self.skill = skill
  
  }

  convenience init?(_ name:String, type:String, stats:[Int]) {
    let ExpectedStatsCount = 8
    
    guard let transformerType = TransformerType.from(type),
      stats.count == ExpectedStatsCount
      else { return nil }
    
    self.init(transformerType,
              name:         name,
              strength:     stats[0],
              intelligence: stats[1],
              speed:        stats[2],
              endurance:    stats[3],
              rank:         stats[4],
              courage:      stats[5],
              firepower:    stats[6],
              skill:        stats[7])
  }
  
  var description: String {
    return "\(type.rawValue):\(name)"
  }

  static func createTeams(from input:[String]) -> (autobots:[Transformer], decepticons:[Transformer]) {
    let ExpectedInputTokens = 10
    
    var autobots = [Transformer]()
    var decepticons = [Transformer]()
  
    for line in input {
      
      let tokens = line.components(separatedBy: ",")
      
      if (tokens.count != ExpectedInputTokens) {
        continue;
      }

      let statTokens = tokens[2..<tokens.endIndex]
        .map({ Int($0.trimmingCharacters(in: .whitespaces)) })
        .flatMap({ $0 })

      guard let robot = Transformer(tokens[0], type: tokens[1], stats: statTokens)
        else { continue }
      
      if (robot.type == .Autobot){
        autobots.append(robot)
      } else {
        decepticons.append(robot)
      }
      
    }
    
    return (autobots.sorted(by: { $0.rank > $1.rank }), decepticons.sorted(by: { $0.rank > $1.rank }))
  }
  
  static func fight(autobots:[Transformer], decepticons:[Transformer]) -> (numberOfMatches:Int, autobotWinners:[Transformer], decepticonWinners:[Transformer]) {
    
    let numberOfMatches = min(autobots.count, decepticons.count)
    let autobots = autobots[0..<numberOfMatches]
    let decepticons = decepticons[0..<numberOfMatches]
    let fighters = zip(autobots, decepticons)
    
    let CourageLimit = 4
    let StrengthLimit = 3
    let SkillLimit = 3
    
    var autobotWinners = [Transformer]()
    var decepticonWinners = [Transformer]()
    
    for (a,d) in fighters {
      
      if ( a.isTeamLeader && d.isTeamLeader ) {
        autobotWinners = [Transformer]()
        decepticonWinners = [Transformer]()
        break;
        
      } else if (a.isTeamLeader) {
        autobotWinners.append(a)
        
      } else if (d.isTeamLeader) {
        decepticonWinners.append(d)
        
      } else if (a.courage - d.courage >= CourageLimit && a.strength - d.strength >= StrengthLimit) {
        autobotWinners.append(a)
      
      } else if (d.courage - a.courage >= CourageLimit && d.strength - a.strength >= StrengthLimit) {
        decepticonWinners.append(d)
      
      } else if (a.skill - d.skill >= SkillLimit) {
        autobotWinners.append(a)
      
      } else if (d.skill - a.skill >= SkillLimit) {
        decepticonWinners.append(d)
      
      } else if (a.overallRating > d.overallRating) {
        autobotWinners.append(a)

      } else if (d.overallRating > a.overallRating) {
        decepticonWinners.append(d)
        
      }
      
    }
    
    return (numberOfMatches, autobotWinners, decepticonWinners)
  }
}

func runBattleSimulation(data:[String]) {
  let (autobots, decepticons) = Transformer.createTeams(from: data)
  let result = Transformer.fight(autobots: autobots, decepticons: decepticons)
  
  var winningTeam = "Tie"
  var losingTeam = ""
  var winners:[Transformer] = []
  var survivors:[Transformer] = []
  
  if (result.autobotWinners.count > result.decepticonWinners.count) {
    winners = autobots
    let nonFighters = decepticons.enumerated().filter({ $0.offset >= result.numberOfMatches }).map({ $0.element })
    survivors = result.decepticonWinners + nonFighters

    winningTeam = TransformerType.Autobot.fullTeamName
    losingTeam = TransformerType.Decepticon.fullTeamName

  } else if (result.decepticonWinners.count > result.autobotWinners.count) {
    winners = decepticons
    let nonFighters = autobots.enumerated().filter({ $0.offset >= result.numberOfMatches }).map({ $0.element })
    survivors = result.autobotWinners + nonFighters

    winningTeam = TransformerType.Decepticon.fullTeamName
    losingTeam = TransformerType.Autobot.fullTeamName

  }
  
  // NOTE: It was unclear what's supposed to be listed in the output regarding the winning team.
  // The options were: the list of all teammates (whether or not they fought),
  //                   the list of all teammates that fought (whether or not they won),
  //                   or the list of all teammates that fought and won
  //
  // The code below uses the 1st option.
  
  let winnerNames = winners.count > 0 ? winners.map({ $0.name }).joined(separator:", ") : "None"
  let survivorNames = survivors.count > 0 ? survivors.map({ $0.name }).joined(separator:", ") : "None"
  
  print ("\(result.numberOfMatches) battle\(result.numberOfMatches == 1 ? "" : "s")")
  print ("Winning team (\(winningTeam)): \(winnerNames)")
  print ("Survivors from the losing team (\(losingTeam)): \(survivorNames)")
  
}

