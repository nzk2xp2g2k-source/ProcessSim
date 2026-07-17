# ProcessSim

**Minimalist chemical process simulator for macOS on Apple Silicon**

## Overview

ProcessSim is a native Swift application that simulates chemical engineering processes. It combines powerful thermodynamic calculations with an intuitive, HYSYS-like graphical interface for designing process flow diagrams (PFD).

## Features

### Core Thermodynamics
- **Three Equation of State Models:**
  - Ideal Gas
  - van der Waals
  - Peng-Robinson (most accurate)
- **16 Built-in Substances** with critical parameters from NIST data
- Stream property calculations: density, enthalpy, compressibility factor
- Saturation pressure correlations (Antoine, Lee-Kesler)

### Process Simulation
- Flash calculations
- Stream mixing with material balance
- Equipment simulation (Inlet, Outlet, Mixer, Heater, Cooler, Flash Separator, Reactors)
- Stream property propagation through equipment network

### User Interface
- Canvas-based Process Flow Diagram (PFD) editor
- Drag-and-drop equipment palette
- Real-time stream property visualization
- Equipment parameter editing

## Building

```bash
# Build the project
swift build

# Run tests
swift test

# Build UI app (macOS only)
swift build --product ProcessSimApp

# Run CLI demo
swift run process-sim
```

## Project Structure

```
Sources/ProcessSim/
├── Core/
│   ├── Substance.swift         # Chemical substance definition
│   ├── Stream.swift            # Material stream with properties
│   └── Composition.swift       # Stream composition (mole fractions)
├── Thermodynamics/
│   └── EquationOfState.swift   # EOS implementations (3 models)
├── Database/
│   └── SubstanceDatabase.swift # 16 industrial chemicals
├── Equipment/
│   ├── Equipment.swift         # Base equipment class + types
│   └── Equipment*.swift        # Specific equipment (Mixer, Heater, etc.)
├── Simulator/
│   └── ProcessSimulator.swift  # Main simulator engine
├── UI/
│   ├── ProcessFlowDiagram.swift    # PFD data model
│   └── EquipmentFactory.swift      # Equipment creation helper
└── ProcessSim.swift            # Public module API
```

## Quick Start

### Using the Library

```swift
import ProcessSim

// Create substances
let db = SubstanceDatabase.shared
let water = db.substance(for: "H2O")!
let ethanol = db.substance(for: "C2H5OH")!

// Create stream
let composition = Composition(substances: [
    (water, 0.5),
    (ethanol, 0.5)
])
let stream = Stream(
    temperature: 350,
    pressure: 101325,
    massFlow: 1.0,
    composition: composition
)

// Calculate properties with different EOS
let pr = PengRobinson()
let simulator = ProcessSimulator(inputStream: stream, eos: pr)
let props = simulator.flashCalculation()

print(props.description)
```

### Building a Process

```swift
import ProcessSim

// Create PFD
let pfd = ProcessFlowDiagram(name: "My Process")

// Add equipment
let inlet = EquipmentFactory.create(.inlet, at: CanvasPosition(x: 50, y: 100))
let mixer = EquipmentFactory.create(.mixer, at: CanvasPosition(x: 200, y: 100))
let outlet = EquipmentFactory.create(.outlet, at: CanvasPosition(x: 350, y: 100))

pfd.addEquipment(inlet)
pfd.addEquipment(mixer)
pfd.addEquipment(outlet)

// Connect equipment
pfd.connect(
    from: inlet.id, sourcePort: inlet.outputStreams[0],
    to: mixer.id, targetPort: mixer.inputStreams[0]
)
```

## Available Substances

- Water (H₂O)
- Ethanol (C₂H₅OH)
- Methane (CH₄)
- Oxygen (O₂)
- Nitrogen (N₂)
- Carbon Dioxide (CO₂)
- Propane (C₃H₈)
- Butane (C₄H₁₀)
- Hydrogen Chloride (HCl)
- Sulfuric Acid (H₂SO₄)
- Ammonia (NH₃)
- Acetone (C₃H₆O)
- Benzene (C₆H₆)
- Toluene (C₇H₈)
- n-Hexane (C₆H₁₄)

## Performance

- Optimized for Apple Silicon (arm64)
- Zero external dependencies
- Fast EOS calculations with Newton-Raphson convergence
- Suitable for real-time UI updates

## Testing

Comprehensive test suite included:

```bash
swift test
```

Tests cover:
- Substance database
- Stream calculations
- All three EOS models
- Stream mixing
- Flash calculations

## Roadmap

### Phase 2: Reactors & Kinetics
- CSTR reactor model with reaction kinetics
- PFR reactor model with conversion calculations
- Reaction network solver

### Phase 3: Separations
- Distillation column model
- VLE (Vapor-Liquid Equilibrium) calculations
- Absorption/desorption columns
- Liquid-liquid extraction

### Phase 4: Advanced UI
- Process simulation runner
- Results visualization (plots, tables)
- Stream table export (CSV, Excel)
- Equipment sizing calculations

### Phase 5: Integration
- NIST API integration for substance properties
- Import/export standard formats (Aspen Plus, DWSIM)
- Multi-component reaction database

## License

MIT

## Author

Developed for macOS on Apple Silicon
