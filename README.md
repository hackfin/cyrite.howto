# Cyrite HDL HOWTO and examples

This is a collection of Jupyter notebooks to provide examples and an ad-hoc reference for the Cyrite hardware development language (in fact: Python). Cyrite HDL (short: cyhdl) is the result of the former myhdl.v2we prototype.
CyHDL is in many ways like MyHDL -- on the front. The major differences:

* Strict interface typing, modular output to VHDL and Verilog dialects
* Blackbox support for external HDL modules
* Simulation APIs for compiled simulations (closed source HDL)
* Performant kernel for procedural generation of logic and interfaces

A binder setup is currently under preparation.

Changelog:
* 9.6.2021   : more consistent signedness support in myhdl signal emulation
* 28.6.2021  : Vector extensions, bulk wrapper and library framework
* 15.7.2021  : Bulk wrapper and @pipeline generators
* 17.10.2021 : Migrate to typechecking, py3.10 and jupyterlab
* 23.10.2021 : Collector/extension revamp, factory class fixes
* 25.1.2022  : Yosys RTLIL and CXXRTL support
* 16.5.2022  : Verilog target, full intbv legacy compatibility behaviour
* 8.5.2024   : The final draft for the CyriteHDL API

