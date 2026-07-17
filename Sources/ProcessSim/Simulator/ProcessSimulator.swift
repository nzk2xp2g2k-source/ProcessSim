import Foundation

/// Главный симулятор процесса
public class ProcessSimulator {
    public var inputStream: Stream
    public var outputStream: Stream?
    
    private let equationOfState: EquationOfState
    private let database: SubstanceDatabase
    
    public init(
        inputStream: Stream,
        eos: EquationOfState = PengRobinson(),
        database: SubstanceDatabase = SubstanceDatabase.shared
    ) {
        self.inputStream = inputStream
        self.equationOfState = eos
        self.database = database
    }
    
    /// Выполнить симуляцию потока без изменений (Flash расчёт)
    public func flashCalculation() -> StreamProperties {
        let density = inputStream.density(using: equationOfState)
        let enthalpy = inputStream.specificEnthalpy(using: equationOfState)
        
        var saturationPressures: [String: Double] = [:]
        
        for (substance, _) in inputStream.composition.substances {
            let Psat = equationOfState.saturationPressure(
                temperature: inputStream.temperature,
                substance: substance
            )
            saturationPressures[substance.formula] = Psat
        }
        
        return StreamProperties(
            temperature: inputStream.temperature,
            pressure: inputStream.pressure,
            massFlow: inputStream.massFlow,
            molarFlow: inputStream.molarFlow,
            density: density,
            specificEnthalpy: enthalpy,
            saturationPressures: saturationPressures
        )
    }
    
    /// Нагреть/охладить поток до новой температуры
    public func changeTemperature(to newTemperature: Double) -> Stream {
        var newStream = inputStream
        newStream.temperature = newTemperature
        return newStream
    }
    
    /// Изменить давление потока
    public func changePressure(to newPressure: Double) -> Stream {
        var newStream = inputStream
        newStream.pressure = newPressure
        return newStream
    }
    
    /// Изменить массовый расход
    public func changeFlow(to newFlow: Double) -> Stream {
        var newStream = inputStream
        newStream.massFlow = newFlow
        return newStream
    }
    
    /// Смешать два потока
    public static func mixStreams(_ stream1: Stream, _ stream2: Stream) -> Stream {
        let totalMass = stream1.massFlow + stream2.massFlow
        
        // Взвешенное среднее температуры и давления
        let avgT = (stream1.temperature * stream1.massFlow + stream2.temperature * stream2.massFlow) / totalMass
        let avgP = (stream1.pressure * stream1.massFlow + stream2.pressure * stream2.massFlow) / totalMass
        
        // Комбинированный состав
        let mol1 = stream1.molarFlow
        let mol2 = stream2.molarFlow
        let totalMol = mol1 + mol2
        
        let comp1Substances = stream1.composition.substances
        let comp2Substances = stream2.composition.substances
        
        var mixedComposition: [(substance: Substance, moleFraction: Double)] = []
        
        // Объединить составы
        for (sub1, frac1) in comp1Substances {
            if let index = comp2Substances.firstIndex(where: { $0.substance.id == sub1.id }) {
                let frac2 = comp2Substances[index].moleFraction
                let mixedFrac = (frac1 * mol1 + frac2 * mol2) / totalMol
                mixedComposition.append((sub1, mixedFrac))
            } else {
                let mixedFrac = frac1 * mol1 / totalMol
                mixedComposition.append((sub1, mixedFrac))
            }
        }
        
        // Добавить компоненты из второго потока, которых нет в первом
        for (sub2, frac2) in comp2Substances {
            if !mixedComposition.contains(where: { $0.substance.id == sub2.id }) {
                let mixedFrac = frac2 * mol2 / totalMol
                mixedComposition.append((sub2, mixedFrac))
            }
        }
        
        let composition = Composition(substances: mixedComposition)
        
        return Stream(
            temperature: avgT,
            pressure: avgP,
            massFlow: totalMass,
            composition: composition
        )
    }
}

// MARK: - StreamProperties

public struct StreamProperties {
    public let temperature: Double
    public let pressure: Double
    public let massFlow: Double
    public let molarFlow: Double
    public let density: Double
    public let specificEnthalpy: Double
    public let saturationPressures: [String: Double]
    
    public var description: String {
        let satPressStr = saturationPressures
            .map { "\($0.key): \(String(format: "%.2e", $0.value)) Pa" }
            .joined(separator: "\n  ")
        
        return """
        === Stream Properties ===
        Temperature:       \(String(format: "%.2f", temperature)) K
        Pressure:          \(String(format: "%.2e", pressure)) Pa
        Mass Flow:         \(String(format: "%.4f", massFlow)) kg/s
        Molar Flow:        \(String(format: "%.6f", molarFlow)) kmol/s
        Density:           \(String(format: "%.2f", density)) kg/m³
        Specific Enthalpy: \(String(format: "%.0f", specificEnthalpy)) J/mol
        
        Saturation Pressures:
          \(satPressStr)
        """
    }
}
