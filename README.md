# myHDL v2we (van twee walletjes eten) prototype examples

This is a prototyping environment Docker container to experiment with an alternative kernel ('myIRL') and revisited myHDL concepts.
Don't use for productive deployment (yet).

The general concept:
* Run binder (see button below), create, simulate and document a hardware design from within a Jupyter notebook
* Use functional programming internals, but develop in readable myHDL
* Extend by derivation.

Limitations:
* modular VHDL output and GHDL simulator only
* No built-in simulator

Changelog:
* 9.6.2021: more consistent signedness support in myhdl signal emulation

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/hackfin/myhdl.v2we.git/HEAD?filepath=examples%2Findex.ipynb)
