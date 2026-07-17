import Foundation

/// Состав потока (молярные доли)
public struct Composition {
    public let substances: [(substance: Substance, moleFraction: Double)]
    
    public init(substances: [(substance: Substance, moleFraction: Double)]) {
        // Нормализация до суммы 1.0
        let sum = substances.reduce(0) { $0 + $1.moleFraction }
        self.substances = substances.map { substance, fraction in
            (substance, fraction / sum)
        }
    }
    
    /// Средняя молекулярная масса смеси
    public var averageMolecularWeight: Double {
        substances.reduce(0) { sum, item in
            sum + item.moleFraction * item.substance.molecularWeight
        }
    }
    
    /// Критическая температура смеси (правило смешения)
    public var criticalTemperature: Double {
        substances.reduce(0) { sum, item in
            sum + item.moleFraction * item.substance.criticalTemperature
        }
    }
    
    /// Критическое давление смеси (правило смешения)
    public var criticalPressure: Double {
        substances.reduce(0) { sum, item in
            sum + item.moleFraction * item.substance.criticalPressure
        }
    }
    
    /// Ацентрический фактор смеси
    public var accentricFactor: Double {
        substances.reduce(0) { sum, item in
            sum + item.moleFraction * item.substance.accentricFactor
        }
    }
}
