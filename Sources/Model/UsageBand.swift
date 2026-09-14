import SwiftUI

/// The colour a ring or bar takes at a given level of use.
///
/// The thresholds come from the mockup, which shows 21% green, 52% yellow and
/// 73% orange. (The prose table in the design spec says 50–79 is yellow, which
/// would make 73% yellow and contradict the frame it claims to describe — the
/// frame wins.)
enum UsageBand: Equatable {
    case ample       // under half
    case watch       // getting close
    case critical    // nearly out
    case exhausted   // limit hit, waiting for the reset

    static func band(for usedFraction: Double, watchThreshold: Double = 0.50, criticalThreshold: Double = 0.70) -> UsageBand {
        switch usedFraction {
        case ..<watchThreshold: return .ample
        case ..<criticalThreshold: return .watch
        case ..<1.00: return .critical
        default:      return .exhausted
        }
    }

    /// `accent` only ever stands in for the ample state's colour — the
    /// warning bands stay fixed regardless of the chosen accent, since their
    /// whole job is to interrupt whatever else is on screen and a
    /// customisable warning colour could be tuned into invisibility.
    func color(accent: Color = Palette.ample, watchColor: Color? = nil, criticalColor: Color? = nil) -> Color {
        switch self {
        case .ample:                 return accent
        case .watch:                 return watchColor ?? Palette.watch
        case .critical, .exhausted:  return criticalColor ?? Palette.critical
        }
    }
}

private struct CodenotchWatchThresholdKey: EnvironmentKey {
    static let defaultValue: Double = 0.50
}

private struct CodenotchCriticalThresholdKey: EnvironmentKey {
    static let defaultValue: Double = 0.70
}

private struct CodenotchWatchColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

private struct CodenotchCriticalColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

private struct CodenotchWeeklyRingDashedKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var codenotchWatchThreshold: Double {
        get { self[CodenotchWatchThresholdKey.self] }
        set { self[CodenotchWatchThresholdKey.self] = newValue }
    }

    var codenotchCriticalThreshold: Double {
        get { self[CodenotchCriticalThresholdKey.self] }
        set { self[CodenotchCriticalThresholdKey.self] = newValue }
    }

    var codenotchWatchColor: Color? {
        get { self[CodenotchWatchColorKey.self] }
        set { self[CodenotchWatchColorKey.self] = newValue }
    }

    var codenotchCriticalColor: Color? {
        get { self[CodenotchCriticalColorKey.self] }
        set { self[CodenotchCriticalColorKey.self] = newValue }
    }
    
    var codenotchWeeklyRingDashed: Bool {
        get { self[CodenotchWeeklyRingDashedKey.self] }
        set { self[CodenotchWeeklyRingDashedKey.self] = newValue }
    }
}
