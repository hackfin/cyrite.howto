import lxml.etree as ET

def convert(xmlfile):
	xsl_filename = 'soc/reg2svg.xsl'

	dom = ET.parse(xmlfile)
	xslt = ET.parse(xsl_filename)
	transform = ET.XSLT(xslt)
	newdom = transform(dom)
	return bytes(newdom)
