//
//  GlucoseG4.swift
//  Loop
//
//  Created by Mark Wilson on 7/21/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import Foundation
import HealthKit
import LoopKit

enum GlucoseLimits {
    static var minimum: UInt16 = 40
    static var maximum: UInt16 = 400
}

extension GlucoseG4: GlucoseValue {
    public var quantity: HKQuantity {
        return HKQuantity(unit: .milligramsPerDeciliter, doubleValue: Double(min(max(glucose, GlucoseLimits.minimum), GlucoseLimits.maximum)))
    }

    public var startDate: Date {
        return time
    }
}


extension GlucoseG4: GlucoseDisplayable {
    public var isStateValid: Bool {
        return glucose >= 20
    }

    public var stateDescription: String {
        if isStateValid {
            return NSLocalizedString("OK", comment: "Sensor state description for the valid state")
        } else {
            return NSLocalizedString("Needs Attention", comment: "Sensor state description for the non-valid state")
        }
    }

    public var trendType: GlucoseTrend? {
        return GlucoseTrend(rawValue: Int(trend))
    }

    public var trendRate: HKQuantity? {
        return nil
    }

    public var isLocal: Bool {
        return true
    }
    
    // TODO Placeholder. This functionality will come with LOOP-1311
    public var glucoseRangeCategory: GlucoseRangeCategory? {
        return nil
    }
}

extension GlucoseG4 {
    public var condition: GlucoseCondition? {
        if glucose < GlucoseLimits.minimum {
            return .belowRange
        } else if glucose > GlucoseLimits.maximum {
            return .aboveRange
        } else {
            return nil
        }
    }
}
