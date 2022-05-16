from myirl.emulation.cyhdl import *

import pyximport
pyximport.install(language_level=3)

from . import cytypes

@factory
class BarrelShifterGenerator(LibraryModule):
	
	def __init__(self, POWER = 5):
		self.power = POWER
		self.width = 2 ** POWER
		super().__init__('bs', targets.VHDL, debug = False)

	@block_component
	def cshift(self, 
			q : Signal.Output,
			a : Signal,
			b : Signal,
			sbit : Signal, 
			msb : Signal,
			asr : (Signal, bool), rotate : (Signal, bool),
			WRAP : bool
		):
		carry = cytypes.Bool() # Carry bit
		u, v = [ cytypes.Bool() for i in range(2) ]
		
		@always_comb
		def assign_carry():
			if asr: # arithmetic shift right
				carry.next = sbit & msb
			else:
				carry.next = 0

		@always_comb
		def assign():
			u.next = a & ~sbit
			
			if rotate == False:         
				if WRAP:
					v.next = carry
				else:
					v.next = b & sbit
			else:
				v.next = b & sbit
				
		@always_comb
		def assign_q():    
			q.next = u | v
			
		return locals()

	@block_component
	def shifter_stage(self,
		w_in : Signal,
		w_out : Signal.Output,
		msb,
		nmux : int, sbit,
		asr : bool, rotate : bool
	):
		inst = []

		DATA_WIDTH = self.width

		# Create signal array
		w = [ Signal(bool()) for i in range(DATA_WIDTH) ]
		wo = concat(*reversed(w))
		wi = [ w_in[i] for i in range(DATA_WIDTH) ]

		MUX_W = DATA_WIDTH // nmux

		for imux in range(nmux):
			tmp = imux * MUX_W
			# print(imux)
			for i in range(tmp, tmp + MUX_W):
				j = i + MUX_W//2
				m = j % DATA_WIDTH
				inst.append(self.cshift(w[m], wi[m], wi[i], sbit,
				            msb, asr, rotate,
							j >= DATA_WIDTH ))

		@always_comb
		def assign():
			w_out.next = wo

		return locals()

	@block_component
	def barrel_shifter(self,
		clk : ClkSignal, ce : Signal,
		val : Signal, s : Signal, result : Signal.Output, \
					   rotate = False):
		
		DATA_WIDTH = self.width
		W_POWER = self.power

		# print("DATA WIDTH", DATA_WIDTH, "ROTATE", rotate)
			
		worker = [ val ]
		worker = worker + [ Signal(intbv()[DATA_WIDTH:]) for i in range(W_POWER) ]
		msb = val[DATA_WIDTH-1]

		sbit = [ s[i] for i in range(len(s))]
		
		shifter_stages = []
		for stage in range(W_POWER):
			K = W_POWER - stage - 1
			# print("Stage %d" % stage)
			shifter_stages.append(
					self.shifter_stage(
						w_in = worker[stage],
						w_out = worker[stage + 1],
						msb = msb,
						nmux = 2 ** stage,
						sbit = sbit[K],
						asr = False, rotate = rotate)
					 )
			
		@always(clk.posedge)
		def result_assign():
			if ce == True:
				result.next = worker[W_POWER]
			
		return locals()
