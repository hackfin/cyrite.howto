# Cyrite HDL HOWTO and examples

This is a collection of Jupyter notebooks to provide examples and an ad-hoc reference for the Cyrite hardware development language (in fact: Python). Cyrite HDL (short: cyhdl) is the result of the former myhdl.v2we prototype.
CyHDL is in many ways like MyHDL -- on the front. The major differences:

* Strict interface typing, modular output to VHDL and Verilog dialects
* Blackbox support for external HDL modules
* Simulation APIs for compiled simulations (closed source HDL)
* Performant kernel for procedural generation of logic and interfaces

Using the Jupyterlab IDE via the Binder below, HDL development
and synthesis can happen in the browser without the needs to install
software.

Overview:

* Generate hardware, simulate and draw waveforms
* Co-Simulate synthesized logic against Python code via yosys/CXXRTL
* HOWTO on migrating/enhancing MyHDL designs

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/hackfin/cyrite.howto/master?urlpath=lab/tree/index.ipynb)

Changelog:
...
* 25.1.2022  : Yosys RTLIL and CXXRTL support
* 16.5.2022  : Verilog target, full intbv legacy compatibility behaviour
* 8.5.2024   : The final draft for the CyriteHDL API

