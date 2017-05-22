//
//  Castle.swift
//  AeqTechnicalAssignment
//
//  Created by asu on 2017-05-19.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

func numberOfCastles(fromElevations elevations:[Int]) -> Int
{
  let noRepeats:[Int] = elevations
    .enumerated()
    .filter({ (offset, elevation) -> Bool in
      return offset == 0 || elevation != elevations[offset - 1]
    })
    .map({ $0.element })
  
  // NOTE: 
  // For a non-empty list of elevations, the FIRST number in the list is treated as a peak or valley.
  //
  // For a non-empty list of elevations, the LAST number in the list is likewise treated as a peak
  // or valley if the number preceding it is not equal to it.
  
  let peaksAndValleys:[Int] = noRepeats
    .enumerated()
    .filter({ (offset:Int, elevation:Int) -> Bool in
      return offset == 0 ||
             offset+1 >= noRepeats.count ||
             (noRepeats[offset-1] < elevation && elevation > noRepeats[offset+1]) ||
             (noRepeats[offset-1] > elevation && elevation < noRepeats[offset+1])
    })
    .map({ $0.element })
  
  return peaksAndValleys.count
}

func surveyCastleSites(onTerrain terrain: [Int])
{
  let castles = numberOfCastles(fromElevations: terrain)
  print ("For Terrain \(terrain), we should build \(castles) castles")
}


