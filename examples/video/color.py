# Color conversion full range (JPEG YCbCr):
#

from myirl.library.style_hdl import *
import numpy
from myhdl import intbv, modbv

mat_jpeg_rgb2yuv = [
	( 0.299,     0.587,           0.114),
	(-0.1687360, -0.331264,  0.5),
	( 0.5,      -0.418688,       -0.081312)
]

# Full range non-level shifted YCbCr to RGB
mat_jpeg_yuv2rgb = [
	(1.0,  0.0,      1.380),
	(1.0, -0.34414, -0.71414),
	(1.0,  1.740,    0.0)
]


a = numpy.matrix(mat_jpeg_rgb2yuv)
# b = numpy.matrix(mat_jpeg_yuv2rgb)
i = numpy.linalg.inv(a)
# mat_jpeg_yuv2rgb = [ ( i.item(0), i.item(1), i.item(2) ),
#                      ( i.item(3), i.item(4), i.item(5) ),
#                      ( i.item(6), i.item(7), i.item(8) ) ]


def FractSigned(val, size):
	return intbv(val, min=-2**(size-1), max=2**(size-1))

def to_fract(val, pos, l):
	return modbv(val[pos:pos-l], min=0, max=2**l)

def FractUnsigned(val, size):
	return intbv(val)[size:]

def vector_to_fp(bits, shift, vec, unsigned = False):
	mask = (-1 << (bits)) ^ (-1)
	one = (1 << (bits - 1))
	scale = float(1 << (shift - 1))
	if unsigned:
		return tuple(map(lambda x: mask & int(x * one / scale), vec))
	else:
		return tuple(map(lambda x: int(x * one / scale), vec))

def hexmatrix(a):
	for i in range(3):
		for j in range(3):
			print(hex(0xffff & int(0.5 + a.item(i*3 + j))))
		print()

if __name__ == "__main__":
	# 1.15 format:
	print("RGB->YUV")
	for i in range(3):
		a = vector_to_fp(16, 1, mat_jpeg_rgb2yuv[i])
		print("0x%04x, 0x%04x, 0x%04x" % (a[0] & 0xffff, a[1] & 0xffff, a[2] & 0xffff))

	print("YUV->RGB")
	# Inverse in 2.14 format, signed
	for i in range(3):
		a = vector_to_fp(16, 2, mat_jpeg_yuv2rgb[i])
		print("0x%04x, 0x%04x, 0x%04x" % (a[0], a[1], a[2]))
	

	# Verify matrixes are ok
	print(80 * "-")
	print("Coeff")
	a = numpy.matrix(mat_jpeg_rgb2yuv)
	hexmatrix(a * 0x8000)
	b = numpy.matrix(mat_jpeg_yuv2rgb)
	print(a * b)
	i = numpy.linalg.inv(a)
	print(80 * "-")
	z = 0x4000 * i
	hexmatrix(z)
	
	
