from myirl.library.bulksignals import bulkwrapper
from myirl.targets import vhdl
from myirl import *

@bulkwrapper(vhdl)
class VideoPattern:
	def __init__(self, mode):
		self.mode     = Signal(intbv(mode)[4:])
		self.barwidth = Signal(intbv(mode)[16:])

@bulkwrapper(vhdl)
class LutPort:
	def __init__(self, bpp=8):
		self.addrin   = Signal(intbv(0)[3:])
		self.addrout  = Signal(intbv(0)[3:])
		self.datain   = Signal(intbv(0)[3*bpp:])
		self.dataout  = Signal(intbv(0)[3*bpp:])
		self.we       = Signal(bool(0))

@bulkwrapper(vhdl)
class VideoPort:
	def __init__(self):
		self.dval     = Signal(bool(0))
		self.lval     = Signal(bool(0))
		self.fval     = Signal(bool(0))

#	Not in MyHDL 0.9 upstream:
#	def assign(self, other):
#		self.dval.next = other.dval
#		self.lval.next = other.lval
#		self.fval.next = other.fval


def RGB(x, bpp=8):
	return Signal(intbv(x)[3*bpp:])
