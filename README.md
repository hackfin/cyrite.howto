# myHDL v2we (van twee walletjes eten) prototype examples

This is a prototyping environment Docker container to experiment with an alternative kernel ('myIRL') and revisited myHDL concepts.

**Cyrite** and myhdl `intbv` compatibility branch used (migration safe)

The general concept:
* Run binder (see button below), create, simulate and document a hardware design from within a Jupyter notebook
* MyHDL -> MyIRL -> Transpilation -> target HDL, RTL
* Extend by derivation.

Limitations:
* modular VHDL and Verilog (limited) output for GHDL and ICARUS simulator
* Experimental: RTLIL conversion via yosys, rudimentary CXXRTL simulator interfacing

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/hackfin/myhdl.v2we/verilog?urlpath=lab/tree/index.ipynb)

Changelog:
* 9.6.2021   : more consistent signedness support in myhdl signal emulation
* 28.6.2021  : Vector extensions, bulk wrapper and library framework
* 15.7.2021  : Bulk wrapper and @pipeline generators
* 17.10.2021 : Migrate to typechecking, py3.10 and jupyterlab
* 23.10.2021 : Collector/extension revamp, factory class fixes
* 25.1.2022  : Yosys RTLIL and CXXRTL support
* 16.5.2022  : Verilog target, full intbv legacy compatibility behaviour
