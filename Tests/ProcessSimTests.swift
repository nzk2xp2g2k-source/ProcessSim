import XCTest
@testable import ProcessSim

final class ProcessSimTests: XCTestCase {
    
    var database: SubstanceDatabase!
    
    override func setUp() {
        super.setUp()
        database = SubstanceDatabase.shared
    }
    
    // MARK: - Substance Database Tests
    
    func testDatabaseLoading() {
        let water = database.substance(for: "H2O")
        XCTAssertNotNil(water)
        XCTAssertEqual(water?.name, "Water")
        XCTAssertEqual(water?.molecularWeight, 18.015, accuracy: 0.001)
    }
    
    func testSubstanceLookup() {
        let ethanol = database.substance(for: "C2H5OH")
        XCTAssertNotNil(ethanol)
        XCTAssertEqual(ethanol?.formula, "C2H5OH")
    }
    
    func testSubstanceCount() {
        let allSubstances = database.allSubstances
        XCTAssert(allSubstances.count >= 16, "Database should have at least 16 substances")
    }
    
    // MARK: - Stream Tests
    
    func testStreamCreation() {
        let water = database.substance(for: "H2O")!
        let composition = Composition(substances: [(water, 1.0)])
        let stream = Stream(temperature: 300, pressure: 101325, massFlow: 1.0, composition: composition)
        
        XCTAssertEqual(stream.temperature, 300)
        XCTAssertEqual(stream.pressure, 101325)
        XCTAssertEqual(stream.massFlow, 1.0)
    }
    
    func testMolarFlow() {
        let water = database.substance(for: "H2O")!
        let composition = Composition(substances: [(water, 1.0)])
        let stream = Stream(temperature: 300, pressure: 101325, massFlow: 18.015, composition: composition)
        
        // 18.015 kg/s воды = 1 kmol/s
        XCTAssertEqual(stream.molarFlow, 1.0, accuracy: 0.001)
    }
    
    // MARK: - Composition Tests
    
    func testCompositionNormalization() {
        let water = database.substance(for: "H2O")!
        let ethanol = database.substance(for: "C2H5OH")!
        
        // Не нормализованный состав
        let composition = Composition(substances: [
            (water, 2.0),
            (ethanol, 2.0)
        ])
        
        let sum = composition.substances.reduce(0) { $0 + $1.moleFraction }
        XCTAssertEqual(sum, 1.0, accuracy: 1e-10)
    }
    
    func testAverageMolecularWeight() {
        let water = database.substance(for: "H2O")!
        let ethanol = database.substance(for: "C2H5OH")!
        
        let composition = Composition(substances: [
            (water, 0.5),
            (ethanol, 0.5)
        ])
        
        let avgMW = composition.averageMolecularWeight
        let expected = (18.015 + 46.068) / 2
        XCTAssertEqual(avgMW, expected, accuracy: 0.001)
    }
    
    // MARK: - Ideal Gas Tests
    
    func testIdealGasDensity() {
        let water = database.substance(for: "H2O")!
        let composition = Composition(substances: [(water, 1.0)])
        
        let eos = IdealGas()
        let density = eos.density(pressure: 101325, temperature: 298.15, composition: composition)
        
        // PV = nRT => ρ = PM/RT
        let R = 8.314462618
        let expected = (101325 * 18.015e-3) / (R * 298.15)
        
        XCTAssertEqual(density, expected, accuracy: 0.01)
    }
    
    func testIdealGasCompressibility() {
        let water = database.substance(for: "H2O")!
        let composition = Composition(substances: [(water, 1.0)])
        
        let eos = IdealGas()
        let Z = eos.compressibilityFactor(pressure: 101325, temperature: 298.15, composition: composition)
        
        XCTAssertEqual(Z, 1.0, accuracy: 1e-10)
    }
    
    // MARK: - van der Waals Tests
    
    func testVanDerWaalsDensity() {
        let nitrogen = database.substance(for: "N2")!
        let composition = Composition(substances: [(nitrogen, 1.0)])
        
        let eos = VanDerWaals()
        let density = eos.density(pressure: 101325, temperature: 298.15, composition: composition)
        
        // Плотность N2 при нормальных условиях ~1.2 kg/m³
        XCTAssert(density > 0.5 && density < 2.0)
    }
    
    func testVanDerWaalsCompressibility() {
        let nitrogen = database.substance(for: "N2")!
        let composition = Composition(substances: [(nitrogen, 1.0)])
        
        let eos = VanDerWaals()
        let Z = eos.compressibilityFactor(pressure: 101325, temperature: 298.15, composition: composition)
        
        // Z должен быть близок к 1 для низких давлений
        XCTAssert(Z > 0.9 && Z <= 1.0)
    }
    
    // MARK: - Peng-Robinson Tests
    
    func testPengRobinsonDensity() {
        let propane = database.substance(for: "C3H8")!
        let composition = Composition(substances: [(propane, 1.0)])
        
        let eos = PengRobinson()
        let density = eos.density(pressure: 101325, temperature: 298.15, composition: composition)
        
        XCTAssert(density > 0, "Density must be positive")
    }
    
    // MARK: - Simulator Tests
    
    func testProcessSimulator() {
        let water = database.substance(for: "H2O")!
        let composition = Composition(substances: [(water, 1.0)])
        let stream = Stream(temperature: 300, pressure: 101325, massFlow: 1.0, composition: composition)
        
        let simulator = ProcessSimulator(inputStream: stream, eos: PengRobinson())
        let props = simulator.flashCalculation()
        
        XCTAssertEqual(props.temperature, 300)
        XCTAssertEqual(props.pressure, 101325)
        XCTAssert(props.density > 0)
    }
    
    func testStreamMixing() {
        let water = database.substance(for: "H2O")!
        let ethanol = database.substance(for: "C2H5OH")!
        
        let comp1 = Composition(substances: [(water, 1.0)])
        let comp2 = Composition(substances: [(ethanol, 1.0)])
        
        let stream1 = Stream(temperature: 300, pressure: 101325, massFlow: 0.5, composition: comp1)
        let stream2 = Stream(temperature: 350, pressure: 101325, massFlow: 0.5, composition: comp2)
        
        let mixed = ProcessSimulator.mixStreams(stream1, stream2)
        
        XCTAssertEqual(mixed.massFlow, 1.0)
        XCTAssertGreaterThan(mixed.temperature, 300)
        XCTAssertLessThan(mixed.temperature, 350)
    }
}
