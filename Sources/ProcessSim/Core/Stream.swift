import Foundation

/// Представляет материальный поток в процессе
public struct Stream {
    public let id: UUID
    public var temperature: Double  // K
    public var pressure: Double      // Pa
    public var massFlow: Double      // kg/s
    public var composition: Composition
    
    /// Получить молярный расход
    public var molarFlow: Double {
        let avgMW = composition.averageMolecularWeight
        return massFlow / (avgMW / 1000) // kg/s -> kmol/s
    }
    
    public init(
        temperature: Double,
        pressure: Double,
        massFlow: Double,
        composition: Composition,
        id: UUID = UUID()
    ) {
        self.id = id
        self.temperature = temperature
        self.pressure = pressure
        self.massFlow = massFlow
        self.composition = composition
    }
    
    /// Удельная энтальпия потока
    public func specificEnthalpy(using eos: EquationOfState) -> Double {
        // Упрощённый расчёт: ΔH = Cp * ΔT
        let cpMix = composition.substances.enumerated().reduce(0.0) { sum, item in
            let (_, substance, moleFraction) = item
            let cp = heatCapacity(substance: substance, T: temperature)
            return sum + moleFraction * cp
        }
        
        let referenceT = 298.15  // K
        return cpMix * (temperature - referenceT)
    }
    
    /// Плотность смеси
    public func density(using eos: EquationOfState) -> Double {
        eos.density(pressure: pressure, temperature: temperature, composition: composition)
    }
    
    // MARK: - Private Helpers
    
    private func heatCapacity(substance: Substance, T: Double) -> Double {
        // Упрощённая модель Cp (дополнить по необходимости)
        let Tr = T / substance.criticalTemperature
        
        // Базовая теплоёмкость идеального газа
        let cpIg = 3.5 * 8.314  // J/(mol·K) для двухатомных молекул
        
        // Корректировка по давлению (простая модель)
        let Pr = pressure / substance.criticalPressure
        let correction = -0.5 * Pr * (Tr - 1.0)
        
        return cpIg * (1.0 + correction)
    }
}

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
