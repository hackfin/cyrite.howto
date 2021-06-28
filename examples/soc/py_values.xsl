<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" 
	xmlns:my="http://www.section5.ch/dclib/schema/devdesc"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:import href="py_regmap.xsl"/>

<xsl:output method="text" encoding="ISO-8859-1"/>	

<!-- This key is needed for register referencing -->
<xsl:key name="regkey" match="my:register" use="@id"/>

<xsl:template name="padded_out">
    <xsl:param name="name"/>
		<xsl:value-of select="substring(concat($name, '                                        '), 1, 40)"/>
</xsl:template>


<xsl:template match="my:item" mode="item_regdef">
<xsl:call-template name="padded_out"><xsl:with-param name="name"><xsl:value-of select="../../my:regref/@bits"/>_<xsl:value-of select="@name"/></xsl:with-param></xsl:call-template>= _BFM_(<xsl:value-of select="./my:value"/>, <xsl:value-of select="../../my:regref/@bits"/>_SHFT, <xsl:value-of select="../../my:regref/@bits"/><xsl:text>)
</xsl:text>
</xsl:template>

<xsl:template match="my:property" mode="bitfield_mode">
	<xsl:text>
# '</xsl:text><xsl:value-of select="@name"/>
	<xsl:text>': #</xsl:text>
	<xsl:value-of select="./my:regref/@ref"/>::<xsl:value-of select="./my:regref/@bits"/>
	<xsl:text>
</xsl:text>
	<xsl:if test="./my:info"><xsl:text>
	{ </xsl:text><xsl:value-of select="my:info"/> }</xsl:if>
	<xsl:apply-templates select=".//my:item" mode="item_regdef"/>
	<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="/">
	<xsl:text># **************************************************************************
# * Contains the register bitfield mode settings.
# *
# * This file was generated by dclib/netpp. Modifications to this file will
# * be lost.
# * Stylesheet: values.xsl       (c) 2004-2014 section5.ch
# *
# * Version: </xsl:text><xsl:value-of select="my:devdesc/my:revision/my:major"/>.<xsl:value-of select="my:devdesc/my:revision/my:minor"/><xsl:value-of select="my:devdesc/my:revision/my:extension"/>
# *
# **************************************************************************/

from bitmanip import _BFM_

<xsl:if test="$header = 1">
<xsl:apply-templates select=".//my:header"/>
</xsl:if>

<xsl:apply-templates select=".//my:property[my:regref/@bits]" mode="bitfield_mode"/>

<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>

