import Foundation

/// Протокол для уравнений состояния
public protocol EquationOfState {
    /// Расчёт плотности смеси
    func density(pressure: Double, temperature: Double, composition: Composition) -> Double
    
    /// Расчёт коэффициента сжимаемости
    func compressibilityFactor(pressure: Double, temperature: Double, composition: Composition) -> Double
    
    /// Расчёт давления насыщенного пара
    func saturationPressure(temperature: Double, substance: Substance) -> Double
    
    /// Имя уравнения состояния
    var name: String { get }
}

// MARK: - Ideal Gas

public struct IdealGas: EquationOfState {
    private let R = 8.314462618  // J/(mol·K)
    
    public var name: String { "Ideal Gas" }
    
    public func density(pressure: Double, temperature: Double, composition: Composition) -> Double {
        let M = composition.averageMolecularWeight / 1000  // kg/mol
        let molarVolume = (R * temperature) / pressure  // m³/mol
        return 1.0 / molarVolume * M  // kg/m³
    }
    
    public func compressibilityFactor(pressure: Double, temperature: Double, composition: Composition) -> Double {
        1.0  // Z = 1 для идеального газа
    }
    
    public func saturationPressure(temperature: Double, substance: Substance) -> Double {
        // Antoine equation: log10(P) = A - B/(C+T)
        // P в bar, T в °C
        // Используем коэффициенты для распространённых веществ
        let T_celsius = temperature - 273.15
        
        // Для воды
        if substance.formula == "H2O" {
            let A = 8.07131
            let B = 1730.63
            let C = 233.426
            let logP = A - B / (C + T_celsius)
            return pow(10.0, logP) * 100000  // bar -> Pa
        }
        
        // По умолчанию используем Clausius-Clapeyron
        return clausius_clapeyron(substance, T: temperature)
    }
    
    private func clausius_clapeyron(_ substance: Substance, T: Double) -> Double {
        let Tc = substance.criticalTemperature
        let Pc = substance.criticalPressure
        let Tr = T / Tc
        
        // Упрощённая модель для давления насыщения
        let omega = substance.accentricFactor
        let B = 0.083 - (0.422 / pow(Tr, 1.6))
        let C = 0.139 - (0.172 / pow(Tr, 4.2))
        
        let logPr = (B + omega * C) / (1.0 - Tr)
        return Pc * pow(10.0, logPr)
    }
}

// MARK: - van der Waals

public struct VanDerWaals: EquationOfState {
    private let R = 8.314462618  // J/(mol·K)
    
    public var name: String { "van der Waals" }
    
    public func density(pressure: Double, temperature: Double, composition: Composition) -> Double {
        let M = composition.averageMolecularWeight / 1000  // kg/mol
        let molarVolume = molarVolumeVdW(pressure: pressure, temperature: temperature, composition: composition)
        return 1.0 / molarVolume * M  // kg/m³
    }
    
    public func compressibilityFactor(pressure: Double, temperature: Double, composition: Composition) -> Double {
        let Vm = molarVolumeVdW(pressure: pressure, temperature: temperature, composition: composition)
        return (pressure * Vm) / (R * temperature)
    }
    
    public func saturationPressure(temperature: Double, substance: Substance) -> Double {
        // Используем Antoine + поправки van der Waals
        let T_celsius = temperature - 273.15
        let A = 8.07131
        let B = 1730.63
        let C = 233.426
        
        var logP = A - B / (C + T_celsius)
        
        // Поправка по ацентрическому фактору
        let omega = substance.accentricFactor
        logP += omega * 0.15
        
        return pow(10.0, logP) * 100000
    }
    
    private func molarVolumeVdW(pressure: Double, temperature: Double, composition: Composition) -> Double {
        let (a, b) = vdwParameters(composition: composition)
        
        // Решаем кубическое уравнение van der Waals численно
        // (P + a/Vm²)(Vm - b) = RT
        // Начальное приближение: идеальный газ
        var Vm = (R * temperature) / pressure
        
        // Newton-Raphson итерации
        for _ in 0..<10 {
            let f = (pressure + a / (Vm * Vm)) * (Vm - b) - R * temperature
            let df = (pressure - a / (Vm * Vm) + 2 * a * b / pow(Vm, 3)) + 
                     (pressure + a / (Vm * Vm))
            
            let newVm = Vm - f / df
            if abs(newVm - Vm) < 1e-8 { break }
            Vm = newVm
        }
        
        return max(Vm, 1e-6)  // Гарантируем положительное значение
    }
    
    private func vdwParameters(composition: Composition) -> (a: Double, b: Double) {
        let R = 8.314462618
        let Tc = composition.criticalTemperature
        let Pc = composition.criticalPressure
        
        let a = 27.0 * pow(R * Tc, 2) / (64.0 * Pc)
        let b = R * Tc / (8.0 * Pc)
        
        return (a, b)
    }
}

// MARK: - Peng-Robinson

public struct PengRobinson: EquationOfState {
    private let R = 8.314462618  // J/(mol·K)
    
    public var name: String { "Peng-Robinson" }
    
    public func density(pressure: Double, temperature: Double, composition: Composition) -> Double {
        let M = composition.averageMolecularWeight / 1000
        let Vm = molarVolumePR(pressure: pressure, temperature: temperature, composition: composition)
        return 1.0 / Vm * M
    }
    
    public func compressibilityFactor(pressure: Double, temperature: Double, composition: Composition) -> Double {
        let Vm = molarVolumePR(pressure: pressure, temperature: temperature, composition: composition)
        return (pressure * Vm) / (R * temperature)
    }
    
    public func saturationPressure(temperature: Double, substance: Substance) -> Double {
        // Используем Lee-Kesler корреляцию
        let Tr = temperature / substance.criticalTemperature
        let omega = substance.accentricFactor
        
        let logPr0 = 5.92714 - (6.09648 / Tr) - 1.28862 * log10(Tr) + 0.169347 * pow(Tr, 6)
        let logPr1 = 15.2518 - (15.6875 / Tr) - 13.4721 * log10(Tr) + 0.43577 * pow(Tr, 6)
        
        let logPr = logPr0 + omega * logPr1
        return substance.criticalPressure * pow(10.0, logPr)
    }
    
    private func molarVolumePR(pressure: Double, temperature: Double, composition: Composition) -> Double {
        let (a, b, kappa) = prParameters(composition: composition, temperature: temperature)
        
        var Vm = (R * temperature) / pressure
        
        for _ in 0..<20 {
            let alpha = 1.0 + kappa * (1.0 - sqrt(temperature / composition.criticalTemperature))
            let alpha2 = alpha * alpha
            
            let f = (pressure * pow(Vm, 3)) - (R * temperature * pow(Vm, 2)) + 
                    (a * alpha2 - R * temperature * b) * Vm - a * b * alpha2
            
            let df = 3 * pressure * (Vm * Vm) - 2 * R * temperature * Vm + 
                     (a * alpha2 - R * temperature * b)
            
            let newVm = Vm - f / df
            if abs(newVm - Vm) < 1e-10 { break }
            Vm = newVm
        }
        
        return max(Vm, 1e-6)
    }
    
    private func prParameters(composition: Composition, temperature: Double) -> (a: Double, b: Double, kappa: Double) {
        let Tc = composition.criticalTemperature
        let Pc = composition.criticalPressure
        let omega = composition.accentricFactor
        
        let a = 0.45724 * pow(R * Tc, 2) / Pc
        let b = 0.07780 * R * Tc / Pc
        let kappa = 0.37464 + 1.54226 * omega - 0.26992 * omega * omega
        
        return (a, b, kappa)
    }
}
