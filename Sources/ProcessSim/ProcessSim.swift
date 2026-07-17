/// The Swift Programming Language
/// https://docs.swift.org/swift-book
///
/// ProcessSim
/// A minimalist process simulator for chemical engineering
///
/// Main public interfaces

public typealias EquationOfState = Thermodynamics.EquationOfState

// Re-export main components
public typealias Substance = Core.Substance
public typealias Stream = Core.Stream
public typealias Composition = Core.Composition

// Export EOS implementations
public typealias IdealGas = Thermodynamics.IdealGas
public typealias VanDerWaals = Thermodynamics.VanDerWaals
public typealias PengRobinson = Thermodynamics.PengRobinson

// Export database
public typealias SubstanceDatabase = Database.SubstanceDatabase

// Export simulator
public typealias ProcessSimulator = Simulator.ProcessSimulator
public typealias StreamProperties = Simulator.StreamProperties

// MARK: - Module Organization

enum Core {}
enum Thermodynamics {}
enum Database {}
enum Simulator {}

// Inject implementations into namespaces
extension Core {
    public typealias Substance = ProcessSim.Substance
    public typealias Stream = ProcessSim.Stream
    public typealias Composition = ProcessSim.Composition
}

extension Thermodynamics {
    public protocol EquationOfState {
        func density(pressure: Double, temperature: Double, composition: Composition) -> Double
        func compressibilityFactor(pressure: Double, temperature: Double, composition: Composition) -> Double
        func saturationPressure(temperature: Double, substance: Substance) -> Double
        var name: String { get }
    }
    
    public typealias IdealGas = ProcessSim.IdealGas
    public typealias VanDerWaals = ProcessSim.VanDerWaals
    public typealias PengRobinson = ProcessSim.PengRobinson
}

extension Database {
    public typealias SubstanceDatabase = ProcessSim.SubstanceDatabase
}

extension Simulator {
    public typealias ProcessSimulator = ProcessSim.ProcessSimulator
    public typealias StreamProperties = ProcessSim.StreamProperties
}
