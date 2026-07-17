import Foundation
import ProcessSim

// MARK: - CLI Demo

let db = SubstanceDatabase.shared

// Создаём смесь: 50% этанол + 50% вода
let ethanol = db.substance(for: "C2H5OH")!
let water = db.substance(for: "H2O")!

let composition = Composition(substances: [
    (ethanol, 0.5),
    (water, 0.5)
])

// Создаём входной поток
// T = 350 K, P = 1 атм, массовый расход = 1 kg/s
let inputStream = Stream(
    temperature: 350,
    pressure: 101325,
    massFlow: 1.0,
    composition: composition
)

print("=== ProcessSim CLI Demo ===\n")
print("Input Stream Configuration:")
print("  Temperature: \(inputStream.temperature) K")
print("  Pressure: \(inputStream.pressure) Pa")
print("  Mass Flow: \(inputStream.massFlow) kg/s")
print("  Molar Flow: \(String(format: "%.6f", inputStream.molarFlow)) kmol/s")
print("")

// Симулируем с разными уравнениями состояния
let eosModels: [(name: String, eos: any EquationOfState)] = [
    ("Ideal Gas", IdealGas()),
    ("van der Waals", VanDerWaals()),
    ("Peng-Robinson", PengRobinson())
]

for (name, eos) in eosModels {
    print("--- Equation of State: \(name) ---")
    
    let simulator = ProcessSimulator(inputStream: inputStream, eos: eos)
    let props = simulator.flashCalculation()
    
    print(props.description)
    print("")
}

// Демонстрация изменения температуры
print("--- Temperature Effect on Density ---")
let temperatures = [298.15, 350, 400, 450, 500]
let eos = PengRobinson()
let simulator = ProcessSimulator(inputStream: inputStream, eos: eos)

for T in temperatures {
    let stream = simulator.changeTemperature(to: T)
    let density = stream.density(using: eos)
    print("T = \(T) K: ρ = \(String(format: "%.3f", density)) kg/m³")
}

print("\n--- Stream Mixing Demo ---")
let stream1 = Stream(
    temperature: 300,
    pressure: 101325,
    massFlow: 0.5,
    composition: Composition(substances: [(water, 1.0)])
)

let stream2 = Stream(
    temperature: 350,
    pressure: 101325,
    massFlow: 0.5,
    composition: Composition(substances: [(ethanol, 1.0)])
)

let mixedStream = ProcessSimulator.mixStreams(stream1, stream2)
print("Stream 1 (water): T = \(stream1.temperature) K, m = \(stream1.massFlow) kg/s")
print("Stream 2 (ethanol): T = \(stream2.temperature) K, m = \(stream2.massFlow) kg/s")
print("Mixed Stream: T = \(String(format: "%.2f", mixedStream.temperature)) K, m = \(mixedStream.massFlow) kg/s")

print("\n✓ Demo completed successfully!")
