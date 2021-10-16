# Example of an (incomplete) standard logic signal library
#
# Currently this supports VHDL only.
#
from myirl.wire import SLV
from myhdl import intbv
from myirl.kernel.components import *

class SlvSig(Signal):
	"Currently supports VHDL only"
	_builtin = True


	def __add__(self, other):
		raise AttributeError("Add/Sub not supported with this type")

	__radd__ = __sub__ = __rsub__ = __add__

	def __init__(self, init = None, width = None, name = None):
		super().__init__(SLV(init, width), name=name)

	def default(self):
		return self.wire

	def convert_assignment(self, v, target):
		"This custom conversion allows assignment of 'X', U', etc."

		if isinstance(v, SLV):
			if len(v) == 1:
				return "'%s'" % str(v)
			else:
				return '"%s"' % str(v)

		else:
			if len(self.wire) != v.size():
				raise AttributeError("Size mismatch (%d) <= (%d). Needs explicit resizing" % (len(self.wire), v.size()))
			return v.convert(target)
			

class UintSig(Signal):
	def __init__(self, init = None, width = None, name = None):
		super().__init__(name, intbv()[width:])
	
