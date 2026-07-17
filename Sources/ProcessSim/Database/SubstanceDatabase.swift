import Foundation

/// База данных химических веществ с критическими параметрами
public class SubstanceDatabase {
    private var substances: [String: Substance] = [:]
    
    public static let shared = SubstanceDatabase()
    
    private init() {
        loadDefaultSubstances()
    }
    
    /// Получить вещество по ID
    public func substance(for id: String) -> Substance? {
        substances[id]
    }
    
    /// Получить вещество по формуле
    public func substance(for formula: String) -> Substance? {
        substances.values.first { $0.formula == formula }
    }
    
    /// Добавить пользовательское вещество
    public func addSubstance(_ substance: Substance) {
        substances[substance.id] = substance
    }
    
    /// Получить список всех веществ
    public var allSubstances: [Substance] {
        Array(substances.values)
    }
    
    private func loadDefaultSubstances() {
        // Вода
        addSubstance(Substance(
            id: "H2O",
            name: "Water",
            formula: "H2O",
            molecularWeight: 18.015,
            criticalTemperature: 647.096,
            criticalPressure: 22064000,
            criticalDensity: 322,
            accentricFactor: 0.344,
            standardEnthalpy: -285830,  // J/mol
            standardEntropy: 69.95      // J/(mol·K)
        ))
        
        // Этанол
        addSubstance(Substance(
            id: "C2H5OH",
            name: "Ethanol",
            formula: "C2H5OH",
            molecularWeight: 46.068,
            criticalTemperature: 514.0,
            criticalPressure: 6137000,
            criticalDensity: 276,
            accentricFactor: 0.649,
            standardEnthalpy: -277630,
            standardEntropy: 160.7
        ))
        
        // Метан
        addSubstance(Substance(
            id: "CH4",
            name: "Methane",
            formula: "CH4",
            molecularWeight: 16.043,
            criticalTemperature: 190.564,
            criticalPressure: 4599000,
            criticalDensity: 162,
            accentricFactor: 0.011,
            standardEnthalpy: -74520,
            standardEntropy: 186.3
        ))
        
        // Кислород
        addSubstance(Substance(
            id: "O2",
            name: "Oxygen",
            formula: "O2",
            molecularWeight: 31.999,
            criticalTemperature: 154.576,
            criticalPressure: 5043000,
            criticalDensity: 436.1,
            accentricFactor: 0.022,
            standardEnthalpy: 0,
            standardEntropy: 205.2
        ))
        
        // Азот
        addSubstance(Substance(
            id: "N2",
            name: "Nitrogen",
            formula: "N2",
            molecularWeight: 28.014,
            criticalTemperature: 126.21,
            criticalPressure: 3395800,
            criticalDensity: 313.3,
            accentricFactor: 0.040,
            standardEnthalpy: 0,
            standardEntropy: 191.6
        ))
        
        // Диоксид углерода
        addSubstance(Substance(
            id: "CO2",
            name: "Carbon Dioxide",
            formula: "CO2",
            molecularWeight: 44.01,
            criticalTemperature: 304.128,
            criticalPressure: 7377000,
            criticalDensity: 467.6,
            accentricFactor: 0.224,
            standardEnthalpy: -393510,
            standardEntropy: 213.8
        ))
        
        // Пропан
        addSubstance(Substance(
            id: "C3H8",
            name: "Propane",
            formula: "C3H8",
            molecularWeight: 44.096,
            criticalTemperature: 369.83,
            criticalPressure: 4248000,
            criticalDensity: 220,
            accentricFactor: 0.152,
            standardEnthalpy: -103850,
            standardEntropy: 270.3
        ))
        
        // Бутан
        addSubstance(Substance(
            id: "C4H10",
            name: "Butane",
            formula: "C4H10",
            molecularWeight: 58.123,
            criticalTemperature: 425.12,
            criticalPressure: 3797000,
            criticalDensity: 200,
            accentricFactor: 0.200,
            standardEnthalpy: -125790,
            standardEntropy: 310.2
        ))
        
        // Соляная кислота
        addSubstance(Substance(
            id: "HCl",
            name: "Hydrogen Chloride",
            formula: "HCl",
            molecularWeight: 36.461,
            criticalTemperature: 324.7,
            criticalPressure: 8463000,
            criticalDensity: 442,
            accentricFactor: 0.132,
            standardEnthalpy: -92307,
            standardEntropy: 186.9
        ))
        
        // Сульфатная кислота (жидкая)
        addSubstance(Substance(
            id: "H2SO4",
            name: "Sulfuric Acid",
            formula: "H2SO4",
            molecularWeight: 98.079,
            criticalTemperature: 924.0,
            criticalPressure: 8400000,
            criticalDensity: 432,
            accentricFactor: 0.545,
            standardEnthalpy: -811300,
            standardEntropy: 156.9
        ))
        
        // Аммиак
        addSubstance(Substance(
            id: "NH3",
            name: "Ammonia",
            formula: "NH3",
            molecularWeight: 17.031,
            criticalTemperature: 405.4,
            criticalPressure: 11333000,
            criticalDensity: 235,
            accentricFactor: 0.255,
            standardEnthalpy: -45900,
            standardEntropy: 192.8
        ))
        
        // Ацетон
        addSubstance(Substance(
            id: "C3H6O",
            name: "Acetone",
            formula: "C3H6O",
            molecularWeight: 58.08,
            criticalTemperature: 508.1,
            criticalPressure: 4700000,
            criticalDensity: 263,
            accentricFactor: 0.307,
            standardEnthalpy: -248000,
            standardEntropy: 200.4
        ))
        
        // Бензол
        addSubstance(Substance(
            id: "C6H6",
            name: "Benzene",
            formula: "C6H6",
            molecularWeight: 78.108,
            criticalTemperature: 562.05,
            criticalPressure: 4894000,
            criticalDensity: 304,
            accentricFactor: 0.209,
            standardEnthalpy: 82880,
            standardEntropy: 269.2
        ))
        
        // Толуол
        addSubstance(Substance(
            id: "C7H8",
            name: "Toluene",
            formula: "C7H8",
            molecularWeight: 92.139,
            criticalTemperature: 591.75,
            criticalPressure: 4108000,
            criticalDensity: 292,
            accentricFactor: 0.262,
            standardEnthalpy: 50100,
            standardEntropy: 321.0
        ))
        
        // n-Гексан
        addSubstance(Substance(
            id: "C6H14",
            name: "n-Hexane",
            formula: "C6H14",
            molecularWeight: 86.175,
            criticalTemperature: 507.82,
            criticalPressure: 3034000,
            criticalDensity: 264,
            accentricFactor: 0.305,
            standardEnthalpy: -167190,
            standardEntropy: 388.4
        ))
    }
}
