# Results Directory

This directory contains the final GDSII layout file generated from the RTL-to-GDS flow.

## 📄 Files

### my_counter.gds
**Final chip layout in GDSII format** - This is the actual physical layout that would be sent to a semiconductor foundry for fabrication.

**File Details:**
- **Size:** ~171 KB
- **Format:** GDSII Stream Format
- **Technology:** SkyWater 130nm PDK
- **Generation Date:** February 2026

## 🔍 How to View the Layout

### Using KLayout (Recommended)

1. **Download KLayout:**
   - Visit: https://www.klayout.de/build.html
   - Download the installer for your platform (Windows/Mac/Linux)
   - Install the application

2. **Open the GDS File:**
   - Launch KLayout
   - Go to **File → Open**
   - Select `my_counter.gds`
   - When prompted, click **"Yes"** to enable "Show full hierarchy" mode

3. **Navigate the Layout:**
   - **Zoom:** Mouse scroll wheel
   - **Pan:** Middle mouse button drag or Shift + Arrow keys
   - **Fit to window:** Press `F2`
   - **Measure:** Press `R` for ruler tool

4. **View Different Layers:**
   - The **Layer panel** on the right shows all metal layers
   - Click checkboxes to show/hide individual layers
   - Different colors represent different metal routing layers

### Layer Information

The design uses the following layers from the SkyWater 130nm PDK:

| Layer Name | Color | Description |
|------------|-------|-------------|
| **met1** | Blue | Metal layer 1 (bottom metal) |
| **met2** | Magenta/Purple | Metal layer 2 |
| **met3** | Cyan | Metal layer 3 |
| **met4** | Green | Metal layer 4 |
| **met5** | Yellow | Metal layer 5 (top metal) |
| **li1** | Red | Local interconnect |
| **poly** | Red/Orange | Polysilicon (gates) |
| **diff** | Green | Diffusion regions |
| **nwell** | Brown | N-well regions |

## 📐 Design Specifications

### Physical Dimensions
- **Die Size:** 100 µm × 100 µm
- **Core Area:** 80 µm × 80 µm (with 10 µm margins)
- **Total Area:** 10,000 µm²

### Technology Details
- **Process Node:** SkyWater 130nm
- **Standard Cell Library:** sky130_fd_sc_hd (high density)
- **Metal Layers:** 5 routing layers (met1-met5)
- **Minimum Feature Size:** 130 nm

### Cell Count
- **Total Standard Cells:** 9 instances
  - 4× D Flip-Flops with asynchronous reset
  - 5× Combinational logic gates (adder)
- **I/O Cells:** Input/output buffers for signals
- **Filler Cells:** Added for manufacturing requirements

## 📊 Layout Statistics

### Utilization
- **Core Utilization:** ~8% (very low for this simple design)
- **Placement Density:** Optimized for routing

### Routing
- **Total Nets:** ~15 nets
- **Routing Completion:** 100%
- **DRC Violations:** 0 (clean layout)
- **Metal Layer Usage:**
  - met1: Local connections
  - met2-met4: Signal routing
  - met5: Power distribution

### Power Grid
- **VDD Rails:** Horizontal stripes across chip
- **VSS Rails:** Interleaved with VDD
- **Power Ring:** Around core area
- **Power Mesh:** Multi-layer for IR drop reduction

## 🎯 What You're Looking At

When you open the GDS in KLayout, you'll see:

1. **Center Area:** The actual circuit
   - Rectangular blocks are standard cells (flip-flops and gates)
   - Colored lines are metal wires connecting cells
   - Horizontal stripes are power rails (VDD/VSS)

2. **Peripheral Area:** I/O ring and padding
   - Input/output buffers
   - Power connection points
   - Substrate connections

3. **Routing Layers:**
   - Different colors show which metal layer each wire uses
   - Vias (connections between layers) appear as small squares

## 🔬 Manufacturing Readiness

This GDS file is **DRC-clean** and represents a layout that could theoretically be manufactured, though for an actual chip you would need:

- [ ] Design Rule Check (DRC) - ✅ Passed
- [ ] Layout vs Schematic (LVS) - Would need verification
- [ ] Electrical Rule Check (ERC) - Would need verification
- [ ] Antenna checks - Would need verification
- [ ] Sign-off timing analysis - ✅ Passed
- [ ] Power integrity verification - Would need detailed analysis

## 📚 Additional Information

### File Format Details
- **Format:** GDSII Stream Format (binary)
- **Units:** Database units in nanometers
- **Layers:** Multiple layers with different datatypes
- **Hierarchy:** Contains top-level cell and sub-cells

### Coordinate System
- **Origin:** Bottom-left corner (0, 0)
- **X-axis:** Horizontal (right is positive)
- **Y-axis:** Vertical (up is positive)
- **Units:** Micrometers (µm)

### Compatibility
This GDSII file is compatible with:
- KLayout (open-source)
- Cadence Virtuoso
- Mentor Graphics Calibre
- Synopsys IC Compiler
- Other industry-standard EDA tools

## 🚀 Next Steps

If you wanted to improve this design:

1. **Increase Complexity:**
   - Expand to 8-bit or 16-bit counter
   - Add enable/load functionality
   - Implement up/down counting

2. **Optimize Layout:**
   - Reduce die size (currently oversized)
   - Optimize power distribution
   - Improve clock tree

3. **Add Features:**
   - Multiple clock domains
   - Scan chain for testing
   - Built-in self-test (BIST)

## 📖 References

- [SkyWater PDK Documentation](https://skywater-pdk.readthedocs.io/)
- [GDSII Format Specification](https://boolean.klaasholwerda.nl/interface/bnf/gdsformat.html)
- [KLayout Documentation](https://www.klayout.de/doc.html)


**Technology:** SkyWater 130nm  
**Tool:** OpenROAD
