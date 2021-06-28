<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" 
	xmlns:my="http://www.section5.ch/dclib/schema/devdesc"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="text" encoding="ISO-8859-1"/>	

	<!-- Source file name -->
	<xsl:param name="srcfile">"-UNKNOWN-"</xsl:param>
	<!-- Register definition prefix -->
	<xsl:param name="regprefix">Reg_</xsl:param>
	<!-- Index of desired device -->
	<xsl:param name="selectDevice">1</xsl:param>
	<!-- If set, convert bit fields -->
	<xsl:param name="convertBitfields">0</xsl:param>
	<!-- If set, use register name as bitfield prefix -->
	<xsl:param name="useBitfieldPrefix">0</xsl:param>
	<!-- If set, convert bit fields -->
	<!-- If 1, use parent register map's name as prefix -->
	<xsl:param name="useMapPrefix">0</xsl:param>
	<xsl:param name="wideRegister">0</xsl:param>
	<xsl:param name="header">1</xsl:param>
	<xsl:variable name="index" select="number($selectDevice)"></xsl:variable>

	<!-- Padding variables -->
	<xsl:variable name="padreg">

		<xsl:choose>
			<xsl:when test="$wideRegister = 1">
			<xsl:text>                                        </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text>                              </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="padreg_n" select="number(40)"/>
	<xsl:variable name="padbf">
		<xsl:text>                                    </xsl:text>
	</xsl:variable>
	<xsl:variable name="padbf_n" select="number(48)">
	</xsl:variable>

	<xsl:template name="padded_out">
		<xsl:param name="pad"><xsl:value-of select="$padreg"/></xsl:param>
		<xsl:param name="padn"><xsl:value-of select="$padreg_n"/></xsl:param>
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="$wideRegister = 1">
			<xsl:value-of select="$name"/>
			<xsl:text> \
                                </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="substring(concat($name, $pad), 1, $padn)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Register definition/declaration and reference -->

	<xsl:template match="my:registermap" mode="reg_decl">

#*********************************************************
#* Address segment '<xsl:value-of select="@name"/>'<xsl:if test="./my:info">
#*
#* <xsl:value-of select="./my:info"/></xsl:if>
#*********************************************************/
		<xsl:choose>
		<xsl:when test="@offset">
<xsl:value-of select="@name"/>_Offset REGISTERMAP_OFFSET(<xsl:value-of select="@offset"/>)
</xsl:when>
			<xsl:otherwise>
try:
<xsl:text>	</xsl:text><xsl:value-of select="@name"/>_Offset = Unit_Offset_<xsl:value-of select="@id"/>
except:
<xsl:text>	</xsl:text><xsl:value-of select="@name"/>_Offset = 0
</xsl:otherwise>
		</xsl:choose>
<xsl:apply-templates select=".//my:register" mode="reg_decl"/>
	</xsl:template>

	<xsl:template match="my:register" mode="reg_decl">
 
# Register <xsl:value-of select="@id"/>
	<xsl:text>
</xsl:text>
	<xsl:call-template name="padded_out">
		<xsl:with-param name="name">
			<xsl:value-of select="$regprefix"/>
				<xsl:if test="$useMapPrefix > 0">
					<xsl:value-of select="../@name"/>_</xsl:if>
			<xsl:value-of select="@id"/>
			<xsl:text> = </xsl:text>
		</xsl:with-param>
	</xsl:call-template>
<xsl:text> </xsl:text>(<xsl:value-of select="../@name"/>_Offset + <xsl:value-of select="@addr"/>)<xsl:if test="$convertBitfields = 1">
<xsl:apply-templates select=".//my:bitfield" mode="reg_decl"/></xsl:if></xsl:template>

	<xsl:template match="my:bitfield" mode="reg_decl">
	<xsl:variable name="name">
		<xsl:choose>
			<xsl:when test="$useBitfieldPrefix &gt; 0">
				<xsl:value-of select="../@id"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:text>
</xsl:text>
	<xsl:call-template name="padded_out">
		<xsl:with-param name="name">
			<xsl:value-of select="$name"/>
		</xsl:with-param>
	</xsl:call-template>

	<xsl:choose>
		<xsl:when test="@lsb = @msb">= _BIT_(<xsl:value-of select="@lsb"/><xsl:text>)</xsl:text>
			<xsl:text>
</xsl:text>
			<xsl:value-of select="$name"/>_SHFT = <xsl:value-of select="@lsb"/>
		</xsl:when>
		<xsl:when test="@lsb > @msb">= _BITMASK_(<xsl:value-of select="@lsb"/>, <xsl:value-of select="@msb"/><xsl:text>)</xsl:text>
			<xsl:text>
</xsl:text>
			<xsl:value-of select="$name"/>_SHFT = <xsl:value-of select="@msb"/>
			<xsl:text>
raise ValueError("MSB and LSB swapped in bitfield definition")</xsl:text>
		</xsl:when>
		<xsl:otherwise>= _BITMASK_(<xsl:value-of select="@msb"/>, <xsl:value-of select="@lsb"/>
			<xsl:text>)</xsl:text>
			<xsl:text>
</xsl:text>
			<xsl:value-of select="$name"/>_SHFT = <xsl:value-of select="@lsb"/>
		</xsl:otherwise>
	</xsl:choose>

	<xsl:if test="./my:info"><xsl:text>     </xsl:text># <xsl:value-of select="my:info"/> </xsl:if></xsl:template>

<!-- Emit header content if language not defined, or if set to "C" -->
<xsl:template match="my:header">
	<xsl:choose>
		<xsl:when test="@language = 'Python'">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:when test="@language">
# Header for language '<xsl:value-of select="./@language"/>' not emitted.
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="versioninfo">v<xsl:value-of select="my:revision/my:major"/>.<xsl:value-of select="my:revision/my:minor"/><xsl:value-of select="my:revision/my:extension"/>

</xsl:template>

<xsl:template match="my:item" mode="unit_map">
	<xsl:text>#define Unit_Offset_</xsl:text><xsl:value-of select="@name"/>
	<xsl:text> REGISTERMAP_OFFSET((</xsl:text><xsl:value-of select="my:value"/>
	<xsl:text>) &lt;&lt; UNIT_ADDR_SHIFT)
</xsl:text>
</xsl:template>

<xsl:template match="my:device">
#******************************************************
#*  DEVICE <xsl:value-of select="@name"/>
#******************************************************
#* <xsl:value-of select="my:info"/>
#*
#* Device description version:
#* <xsl:call-template name="versioninfo"/>
#**************************************************************************/

<xsl:if test="my:group[@name='UNIT_MAP']">
# Unit map offset definitions:

<xsl:text>#define UNIT_ADDR_SHIFT </xsl:text>
<xsl:value-of select="my:group[@name='UNIT_MAP']/my:property/my:regref/@bits"/>_SHFT
 
<xsl:apply-templates select="my:group[@name='UNIT_MAP']/my:property/my:choice/my:item" mode="unit_map" />

</xsl:if>

#
HWREV_<xsl:value-of select="@id"/>_MAJOR = <xsl:value-of select="my:revision/my:major"/>
HWREV_<xsl:value-of select="@id"/>_MINOR = <xsl:value-of select="my:revision/my:minor"/>
HWREV_<xsl:value-of select="@id"/>_EXT   = "<xsl:value-of select="my:revision/my:extension"/>"
<xsl:apply-templates select=".//my:registermap[not(@nodecode='true') or not(@hidden) or (@hidden='false')]" mode="reg_decl"/>

<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="/">
<xsl:text># DEVICE description file /definitions
# This file was generated by dclib/netpp. Modifications to this file will
# be lost.
</xsl:text>
#
# Source file:<xsl:value-of select="$srcfile"/>
# Stylesheet:  registermap v0.4             (c) 2010-2015 section5.ch
#


<xsl:if test="my:vendor">
VENDOR_TAG = <xsl:value-of select="my:vendor"/>
</xsl:if>

from bitmanip import _BIT_, _BITMASK_

# Allow to define an external offset
def REGISTERMAP_OFFSET(x):
	return (x)


<xsl:choose>
	<xsl:when test="string($index) != 'NaN'">
		<xsl:apply-templates select="my:devdesc/my:device[$index]"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="my:devdesc/my:device[@id=$selectDevice]"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

