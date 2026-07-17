import Foundation

/// Представляет химическое вещество с критическими параметрами
public struct Substance: Codable, Identifiable {
    public let id: String
    public let name: String
    public let formula: String
    public let molecularWeight: Double  // г/моль
    
    // Критические параметры
    public let criticalTemperature: Double  // K
    public let criticalPressure: Double      // Pa
    public let criticalDensity: Double       // kg/m³
    
    // Ацентрический фактор (для EOS)
    public let accentricFactor: Double
    
    // Стандартные термодинамические данные
    public let standardEnthalpy: Double      // J/mol (при 298.15 K)
    public let standardEntropy: Double       // J/(mol·K) (при 298.15 K)
    
    public init(
        id: String,
        name: String,
        formula: String,
        molecularWeight: Double,
        criticalTemperature: Double,
        criticalPressure: Double,
        criticalDensity: Double,
        accentricFactor: Double,
        standardEnthalpy: Double = 0,
        standardEntropy: Double = 0
    ) {
        self.id = id
        self.name = name
        self.formula = formula
        self.molecularWeight = molecularWeight
        self.criticalTemperature = criticalTemperature
        self.criticalPressure = criticalPressure
        self.criticalDensity = criticalDensity
        self.accentricFactor = accentricFactor
        self.standardEnthalpy = standardEnthalpy
        self.standardEntropy = standardEntropy
    }
}

extension Substance {
    /// Вспомогательные параметры для расчётов
    public var reducedTemperature: (T: Double) -> Double {
        { T in T / self.criticalTemperature }
    }
    
    public var reducedPressure: (P: Double) -> Double {
        { P in P / self.criticalPressure }
    }
}
