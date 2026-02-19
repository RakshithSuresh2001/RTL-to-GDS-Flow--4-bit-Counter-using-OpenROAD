# RTL-to-GDS Flow: 4-bit Counter using OpenROAD

A complete digital ASIC design flow from RTL (Verilog) to GDSII layout using OpenROAD on Docker with the SkyWater 130nm open-source PDK.

![Project Status](https://img.shields.io/badge/status-completed-success)
![Technology](https://img.shields.io/badge/tech-SkyWater%20130nm-blue)
![Tool](https://img.shields.io/badge/tool-OpenROAD-orange)

## 📋 Table of Contents

- [Overview](#overview)
- [Design Specifications](#design-specifications)
- [Results](#results)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Running the Design](#running-the-design)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## 🎯 Overview

This project demonstrates a complete RTL-to-GDS implementation of a simple 4-bit up counter with asynchronous reset. The design goes through all stages of the digital IC design flow:

1. **RTL Design** (Verilog)
2. **Synthesis** (Yosys)
3. **Floorplanning**
4. **Placement**
5. **Clock Tree Synthesis (CTS)**
6. **Routing**
7. **GDSII Generation**

**Technology:** SkyWater 130nm open-source PDK  
**Tools:** OpenROAD Flow Scripts (ORFS)  
**Platform:** Docker on Windows with WSL2

## 📐 Design Specifications

### Circuit Description
A simple 4-bit synchronous up counter with:
- **Clock input** (`clk`)
- **Active-low asynchronous reset** (`rst_n`)
- **4-bit output** (`count[3:0]`)

### RTL Code
```verilog
module counter (
  input wire clk,
  input wire rst_n,
  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      count <= 4'b0000;
    else
      count <= count + 4'b0001;
  end

endmodule
```

### Timing Constraints
- **Target Clock Frequency:** 100 MHz (10 ns period)
- **Input Delay:** 0.5 ns
- **Output Delay:** 0.5 ns

## 📊 Results

### Performance Metrics

| Metric | Value |
|--------|-------|
| **Maximum Frequency** | **289.58 MHz** |
| **Target Frequency** | 100 MHz |
| **Timing Slack** | +6.55 ns |
| **Clock Period (min)** | 3.45 ns |
| **Clock Skew** | 0.00 ns (perfect) |
| **Total Power** | **49.7 µW** |
| **Die Area** | 100 µm × 100 µm |
| **Flow Completion Time** | 7 seconds |

### Power Breakdown

| Component | Power (µW) | Percentage |
|-----------|-----------|------------|
| Clock Network | 32.7 | 65.9% |
| Sequential Logic | 16.3 | 32.8% |
| Combinational Logic | 0.64 | 1.3% |
| **Total** | **49.7** | **100%** |

### Design Statistics
- **Standard Cells:** 9 instances
  - 4× D Flip-Flops (DFF)
  - 5× Combinational gates (adder logic)
- **Metal Layers Used:** met1 through met5
- **Routing Success:** 100% (no DRC violations)

## 🔧 Prerequisites

### Required Software
- **Docker Desktop** (with WSL2 enabled on Windows)
- **Git**
- **KLayout** (for viewing GDSII files)

### System Requirements
- **RAM:** Minimum 12 GB allocated to Docker/WSL2
- **Disk Space:** ~10 GB for tools and builds
- **OS:** Windows 10/11 with WSL2, or Linux

## 🚀 Installation & Setup

### Step 1: Configure WSL2 Memory

Create/edit `.wslconfig` in your Windows home directory (`C:\Users\YourName\.wslconfig`):

```ini
[wsl2]
memory=12GB
processors=4
swap=4GB
```

Restart WSL:
```powershell
wsl --shutdown
```

### Step 2: Launch Docker Container

```powershell
docker run -it --platform linux/amd64 openroad/orfs:latest bash
```

### Step 3: Clone OpenROAD Flow Scripts

Inside the container:
```bash
cd /
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
cd OpenROAD-flow-scripts
```

### Step 4: Build Tools from Source

**Note:** This step is required if you encounter "illegal instruction" errors with pre-built binaries.

```bash
./build_openroad.sh --local --clean --threads 4
```

This takes approximately 30-60 minutes.

## 🏃 Running the Design

### 1. Create Design Directory Structure

```bash
cd /OpenROAD-flow-scripts
mkdir -p flow/designs/src/my_counter
mkdir -p flow/designs/sky130hd/my_counter
```

### 2. Create Verilog Source File

`flow/designs/src/my_counter/counter.v`:
```verilog
module counter (
  input wire clk,
  input wire rst_n,
  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      count <= 4'b0000;
    else
      count <= count + 4'b0001;
  end

endmodule
```

### 3. Create SDC Constraints

`flow/designs/src/my_counter/counter.sdc`:
```tcl
# Define 100 MHz clock (10ns period)
create_clock -name clk -period 10 [get_ports clk]

# Input/output delays
set_input_delay  0.5 -clock clk [get_ports rst_n]
set_output_delay 0.5 -clock clk [get_ports count*]

# Load constraints
set_load 0.05 [all_outputs]
```

### 4. Create Configuration File

`flow/designs/sky130hd/my_counter/config.mk`:
```makefile
export DESIGN_NAME     = counter
export PLATFORM        = sky130hd
export DESIGN_NICKNAME = my_counter

export VERILOG_FILES   = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/counter.v
export SDC_FILE        = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/counter.sdc

# Use fixed die size
export DIE_AREA    = 0 0 100 100
export CORE_AREA   = 10 10 90 90

# Clock port
export CLOCK_PORT = clk
```

### 5. Run the Complete Flow

```bash
cd flow
make DESIGN_CONFIG=./designs/sky130hd/my_counter/config.mk
```

### 6. View Results

```bash
# Timing and power report
cat reports/sky130hd/my_counter/base/6_finish.rpt

# Routing report
cat reports/sky130hd/my_counter/base/5_route_drc.rpt

# Check GDS file
ls -lh results/sky130hd/my_counter/base/6_final.gds
```

### 7. Export GDS to Windows

From PowerShell (on host machine):
```powershell
# Get container ID
docker ps

# Copy GDS file
docker cp <container_id>:/OpenROAD-flow-scripts/flow/results/sky130hd/my_counter/base/6_final.gds C:\Users\YourName\Desktop\my_counter.gds
```

### 8. Visualize Layout in KLayout

1. Download and install [KLayout](https://www.klayout.de/build.html)
2. Open KLayout
3. File → Open → Select `my_counter.gds`
4. When prompted, choose "Yes" to show full hierarchy

## 📁 Project Structure

```
OpenROAD-flow-scripts/
├── flow/
│   ├── designs/
│   │   ├── src/
│   │   │   └── my_counter/
│   │   │       ├── counter.v          # RTL source
│   │   │       └── counter.sdc        # Timing constraints
│   │   └── sky130hd/
│   │       └── my_counter/
│   │           └── config.mk          # Design configuration
│   ├── results/
│   │   └── sky130hd/
│   │       └── my_counter/
│   │           └── base/
│   │               └── 6_final.gds    # Final GDSII layout
│   ├── reports/
│   │   └── sky130hd/
│   │       └── my_counter/
│   │           └── base/
│   │               ├── 6_finish.rpt   # Final timing/power
│   │               ├── 4_cts_final.rpt
│   │               └── 5_route_drc.rpt
│   └── logs/                          # Build logs
└── tools/                             # OpenROAD tools
```

## 🔍 Design Flow Stages

### Stage 1: Synthesis (Yosys)
- Converts RTL to gate-level netlist
- Technology mapping to sky130 standard cells
- Optimization for area and timing

### Stage 2: Floorplanning
- Die and core area definition
- I/O placement
- Power grid generation (PDN)

### Stage 3: Placement
- Global placement (spreading cells)
- Detailed placement (legal positions)
- Buffer insertion

### Stage 4: Clock Tree Synthesis (CTS)
- Clock network generation
- Skew minimization
- Clock buffer insertion

### Stage 5: Routing
- Global routing (topology)
- Detailed routing (actual metal traces)
- Via insertion

### Stage 6: Finishing
- Metal fill insertion
- GDSII stream generation
- DRC/LVS checking

## 🛠️ Troubleshooting

### Issue: "illegal instruction" Error During CTS

**Cause:** Pre-built binaries incompatible with your CPU

**Solution:** Build tools from source
```bash
cd /OpenROAD-flow-scripts
./build_openroad.sh --local --clean --threads 4
```

### Issue: "g++: fatal error: Killed signal"

**Cause:** Insufficient memory during compilation

**Solution:** Increase WSL2 memory in `.wslconfig`:
```ini
[wsl2]
memory=16GB
```

### Issue: PDN Error "PDN-0185"

**Cause:** Die area too small for power grid

**Solution:** Increase die size in `config.mk`:
```makefile
export DIE_AREA = 0 0 100 100
export CORE_AREA = 10 10 90 90
```

### Issue: GUI Warning "makeCurrent() failed"

**Cause:** Docker doesn't have X11/graphics support

**Solution:** This is expected. Export GDS and view with KLayout on host machine instead.

## 📚 References

### Official Documentation
- [OpenROAD Project](https://theopenroadproject.org/)
- [OpenROAD Flow Scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
- [SkyWater 130nm PDK](https://github.com/google/skywater-pdk)
- [KLayout Documentation](https://www.klayout.de/doc.html)

### Learning Resources
- [OpenROAD Tutorials](https://openroad.readthedocs.io/)
- [Digital ASIC Design Flow](https://en.wikipedia.org/wiki/Application-specific_integrated_circuit)
- [VLSI CAD Tools](https://opencircuitdesign.com/)

## 🎓 Key Learnings

1. **Complete RTL-to-GDS flow** using open-source tools
2. **Docker containerization** for reproducible chip design
3. **Timing closure** - design achieved 2.9× target frequency
4. **Power analysis** - understanding clock vs logic power
5. **Physical design** - from netlist to GDSII layout
6. **Standard cell libraries** and technology mapping
7. **Clock tree synthesis** for zero skew distribution

## 📝 Future Improvements

- [ ] Add enable signal to counter
- [ ] Implement up/down counter functionality
- [ ] Add parallel load capability
- [ ] Increase bit width (8-bit, 16-bit)
- [ ] Add overflow/underflow detection
- [ ] Implement multiple clock domains
- [ ] Add scan chain for DFT

## 🤝 Acknowledgments

- **OpenROAD Project** for the open-source EDA tools
- **SkyWater Technology** and **Google** for the 130nm PDK
- Anthropic Claude for technical guidance and troubleshooting

## 📄 License

This project uses open-source tools and PDKs:
- OpenROAD: BSD 3-Clause License
- SkyWater PDK: Apache 2.0 License

---

**Project Completed:** February 2026  
**Author:** Rakshith Suresh

**Technology:** SkyWater 130nm  
**Tools:** OpenROAD, Docker, KLayout
