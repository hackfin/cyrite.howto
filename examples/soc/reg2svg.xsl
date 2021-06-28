<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- register to SVG converter

(c) 2010, Martin Strubel <hackfin@section5.ch>

-->

<xsl:stylesheet version="1.0" 
  xmlns="http://www.w3.org/2000/svg"
  xmlns:my="http://www.section5.ch/dclib/schema/devdesc"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>
<!-- Specify register id to convert -->
<xsl:param name="register">-1</xsl:param>
<!-- If 1, use parent register map's name as prefix -->
<xsl:param name="useMapPrefix">1</xsl:param>


<!-- xsl:import href="utils.xsl"/ -->
<xsl:template name="draw_bitno">
  <xsl:param name="i" select="7"/>
  <xsl:param name="xoff" select="4"/>

  <xsl:if test="$i &gt; 0">
    <xsl:call-template name="draw_bitno">
    <xsl:with-param name="i" select="$i - 1"/>
    <xsl:with-param name="xoff" select="$xoff + 16"/>
    </xsl:call-template>
  </xsl:if>

  <g>
    <xsl:attribute name="transform">translate(<xsl:value-of select="$xoff + 4"/>, -2)</xsl:attribute>
    <text>
      <xsl:attribute name="text-anchor">middle</xsl:attribute>
      <xsl:attribute name="font-family">Courier</xsl:attribute>
      <xsl:attribute name="font-size">6</xsl:attribute>
      <xsl:value-of select="$i"/>
    </text>
  </g>


</xsl:template>

<xsl:template name="draw_default">
  <xsl:param name="i" select="0"/>
  <xsl:param name="n" select="8"/>
  <xsl:param name="xoff" select="4"/>
  <xsl:param name="data" select="4"/>

  <xsl:if test="$i &lt; $n">
    <xsl:call-template name="draw_default">
    <xsl:with-param name="n" select="$n"/>
    <xsl:with-param name="i" select="$i + 1"/>
    <xsl:with-param name="xoff" select="$xoff + 16"/>
    <xsl:with-param name="data" select="$data"/>
    </xsl:call-template>
  </xsl:if>

  <g>
    <xsl:attribute name="transform">translate(<xsl:value-of select="$xoff + 4"/>, 9)</xsl:attribute>

    <text>
      <xsl:attribute name="text-anchor">middle</xsl:attribute>
      <xsl:attribute name="font-family">Courier</xsl:attribute>
      <xsl:attribute name="font-size">7</xsl:attribute>
      <xsl:value-of select="substring($data, $i + 1, 1)"/>
    </text>
  </g>


</xsl:template>

<xsl:template name="for-loop">
  <xsl:param name="i"         select="1"/>
  <xsl:param name="increment" select="1"/>
  <xsl:param name="operator">=</xsl:param>
  <xsl:param name="testValue" select="1"/>
  <xsl:param name="iteration" select="1"/>

  <xsl:variable name="testPassed">
    <xsl:choose>
      <xsl:when test="starts-with($operator, '!=')">
        <xsl:if test="$i != $testValue">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="starts-with($operator, '&lt;=')">
        <xsl:if test="$i &lt;= $testValue">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="starts-with($operator, '&gt;=')">
        <xsl:if test="$i &gt;= $testValue">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="starts-with($operator, '=')">
        <xsl:if test="$i = $testValue">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="starts-with($operator, '&lt;')">
        <xsl:if test="$i &lt; $testValue">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="starts-with($operator, '&gt;')">
        <xsl:if test="$i &gt; $testValue">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>Sorry, the for-loop emulator only </xsl:text>
          <xsl:text>handles six operators </xsl:text>
          <xsl:value-of select="$newline"/>
          <xsl:text>(&lt; | &gt; | = | &lt; | &gt; | !=). </xsl:text>
          <xsl:text>The value </xsl:text>
          <xsl:value-of select="$operator"/>
          <xsl:text> is not allowed.</xsl:text>
          <xsl:value-of select="$newline"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$testPassed='true'">
    <!-- Put your logic here, whatever it might be. For the purpose      -->
    <!-- of our example, we'll just write some text to the output stream. -->

    <xsl:call-template name="draw_bar">
      <xsl:with-param name="pos" select="$i"/>
    </xsl:call-template>

    <!-- Your logic should end here; don't change the rest of this        -->
    <!-- template!                                                        -->

    <!-- Now for the important part: we increment the index variable and  -->
    <!-- loop. Notice that we're passing the incremented value, not      -->
    <!-- changing the variable itself.                                   -->

    <xsl:call-template name="for-loop">
      <xsl:with-param name="i"         select="$i + $increment"/>
      <xsl:with-param name="increment" select="$increment"/>
      <xsl:with-param name="operator"  select="$operator"/>
      <xsl:with-param name="testValue" select="$testValue"/>
      <xsl:with-param name="iteration" select="$iteration + 1"/>
    </xsl:call-template>
  </xsl:if> 
</xsl:template>

<xsl:template name="draw_bar">
  <xsl:param name="pos"         select="1"/>
  <polyline>
    <xsl:variable name="x" select="number($pos)*16"></xsl:variable>
    <xsl:attribute name="points">
      <xsl:value-of select="$x"/>,<xsl:value-of select="0"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$x"/>,<xsl:value-of select="16"/>
    </xsl:attribute>
    <xsl:attribute name="style">fill:yellow;stroke:gray;stroke-width:0.5</xsl:attribute>
  </polyline>
</xsl:template>


<!-- draw bit field -->
<xsl:template match="my:bitfield" mode="reg_draw">
  <xsl:variable name="off">
    <xsl:choose>
      <xsl:when test="../@size">
        <xsl:value-of select="number(../@size)*128"/>
      </xsl:when>
      <xsl:otherwise>
        128
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="x0" select="$off - number(@lsb)*16"/>
  <xsl:variable name="x1" select="$off - (number(@msb)+1)*16"/>
  <xsl:variable name="tmp" select="$x0 + $x1"/>
  <xsl:variable name="mid" select="$tmp div 2"/>
  <xsl:variable name="y" select="6 + position() * 12"/>
  <xsl:variable name="loff" select="$off + 40"/>

  <xsl:variable name="linestyle">stroke:black;stroke-width:0.5</xsl:variable>

  <xsl:variable name="bracketstyle">
    <xsl:choose>
      <xsl:when test="@lsb &gt; @msb">fill:red</xsl:when>
      <xsl:when test="@access='RO'">fill:gray</xsl:when>
      <xsl:when test="@access='WO'">fill:yellow</xsl:when>
      <xsl:when test="../@access='WO'">fill:yellow</xsl:when>
      <xsl:otherwise>fill:none</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Create bracket and bitfield label: -->

  <g transform="translate(0,18)">
    <polyline>
      <xsl:attribute name="points">
        <xsl:value-of select="$x0"/>,<xsl:value-of select="2"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$x0"/>,<xsl:value-of select="6"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$x1"/>,<xsl:value-of select="6"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$x1"/>,<xsl:value-of select="2"/>
      </xsl:attribute>
      <xsl:attribute name="style"><xsl:value-of select="$bracketstyle"/>;<xsl:value-of select="$linestyle"/></xsl:attribute>
    </polyline>

    <polyline>
      <xsl:attribute name="points">
        <xsl:value-of select="$mid"/>,<xsl:value-of select="6"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$mid"/>,<xsl:value-of select="$y"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$loff"/>,<xsl:value-of select="$y"/>
      </xsl:attribute>
      <xsl:attribute name="style">fill:none;<xsl:value-of select="$linestyle"/></xsl:attribute>
    </polyline>
    <g>
      <xsl:attribute name="transform">translate(<xsl:value-of select="$loff + 4"/>, <xsl:value-of select="$y"/>)</xsl:attribute>
      <text>
        <xsl:attribute name="text-anchor">start</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-family">Courier</xsl:attribute>
        <xsl:attribute name="font-size">8</xsl:attribute>

      <xsl:choose>
        <xsl:when test="@lsb = @msb">
        <xsl:value-of select="@name"/>[<xsl:value-of select="@msb"/>]
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="@name"/>[<xsl:value-of select="@msb"/>:<xsl:value-of select="@lsb"/>]
        </xsl:otherwise>
      </xsl:choose>
      </text>
    </g>
  </g>
</xsl:template>

<xsl:template match="my:register" mode="reg_draw">
  <xsl:param name="standalone">1</xsl:param>

  <xsl:comment>Graph for register <xsl:value-of select="@id"/>
  </xsl:comment>

  <xsl:variable name="size">
    <xsl:choose>
      <xsl:when test="@size">
        <xsl:value-of select="number(@size)"/>
      </xsl:when>
      <xsl:otherwise>
        1
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="rectfill">
    <xsl:choose>
      <xsl:when test="@access='RO'">fill:#e5e5e5;stroke:black;stroke-width:1</xsl:when>
      <xsl:otherwise>fill:none;stroke:black;stroke-width:1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="offset" select="count(preceding-sibling::*) * 48 + (count(preceding-sibling::*/my:bitfield) +1)*12"></xsl:variable>
  <!-- When 'standalone' = 1, don't use an offset -->
  <xsl:variable name="yoff">
    <xsl:choose>
      <xsl:when test="$standalone = 1">0</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$offset"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:comment> offset: <xsl:value-of select="$offset"/>
  </xsl:comment>

  <g>
    <xsl:attribute name="transform">translate(0, <xsl:value-of select="$yoff"/>)</xsl:attribute>
    <g transform="translate(0,8)">
      <text>
        <xsl:attribute name="text-anchor">start</xsl:attribute>
        <xsl:attribute name="font-family">Courier</xsl:attribute>
        <xsl:attribute name="font-size">8</xsl:attribute>
        <xsl:if test="$useMapPrefix = 1"><xsl:value-of select="../@name"/>::</xsl:if>
        <xsl:value-of select="@id"/>
      </text>
    </g>

    <xsl:variable name="i" select="$size * 8"></xsl:variable>
    <xsl:variable name="ox" select="100"></xsl:variable>
    <xsl:variable name="tx" select="$ox + 16*16-16*$i"></xsl:variable>

    <g>
      <xsl:attribute name="transform">translate(<xsl:value-of select="$tx"/>,0)</xsl:attribute>
      <rect>
        <xsl:attribute name="x">0.0</xsl:attribute>
        <xsl:attribute name="y">0.0</xsl:attribute>
        <xsl:attribute name="width">
        <xsl:value-of select="$size * 128.0"/>
        </xsl:attribute>
        <xsl:attribute name="height">16.0</xsl:attribute>
        <xsl:attribute name="style"><xsl:value-of select="$rectfill"/></xsl:attribute>
      </rect>

      <xsl:apply-templates select=".//my:bitfield" mode="reg_draw">
        <xsl:sort select="@msb" data-type="number"/>
      </xsl:apply-templates>

      <!-- If we have default entries, use them: -->
 
      <xsl:if test="my:default">
        <xsl:choose>
          <xsl:when test="my:bitfield">
            <xsl:call-template name="draw_default">
            <xsl:with-param name="n" select="$i - 1"/>
            <xsl:with-param name="data" select="my:default"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <g>
              <xsl:attribute name="transform">translate(<xsl:value-of select="4"/>, 24)</xsl:attribute>

            <text>
              <xsl:attribute name="text-anchor">start</xsl:attribute>
              <xsl:attribute name="font-family">Courier</xsl:attribute>
              <xsl:attribute name="font-size">8</xsl:attribute>
              Default: <xsl:value-of select="my:default"/>
            </text>
            </g>
          </xsl:otherwise>
          </xsl:choose>
      </xsl:if>

    <!-- Draw bars: -->

      <xsl:call-template name="for-loop">
        <xsl:with-param name="i"         select="1"/>
        <xsl:with-param name="increment" select="1"/>
        <xsl:with-param name="operator">!=</xsl:with-param>
        <xsl:with-param name="testValue" select="$i"/>
      </xsl:call-template>

      <!-- Bit numbers: -->
      <xsl:call-template name="draw_bitno">
        <xsl:with-param name="i" select="$size*8-1"/>
      </xsl:call-template>
    </g>

    <g>
      <xsl:attribute name="transform">translate(<xsl:value-of select="$ox + 280"/>, 8)</xsl:attribute>


      <xsl:if test="not(../@nodecode='true')">
        <text>
          <xsl:attribute name="text-anchor">start</xsl:attribute>
          <xsl:attribute name="font-family">Courier</xsl:attribute>
          <xsl:attribute name="font-size">8</xsl:attribute>
          <xsl:value-of select="@addr"/>
        </text>
      </xsl:if>
    </g>
  </g>

</xsl:template>

<xsl:template match="/">
  <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="$register = -1">
      <xsl:value-of select="48 * count(.//my:register) + 12 * count(.//my:register/my:bitfield)"/>
        </xsl:when>
        <xsl:otherwise>
      <xsl:value-of select="48 * count(.//my:register[@id=$register]) + 12 * count(.//my:register[@id=$register]/my:bitfield)"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>

  <svg>
    <xsl:attribute name="width">480</xsl:attribute>
    <xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>

      <xsl:choose>
        <xsl:when test="$register = -1">
      <xsl:apply-templates select=".//my:register" mode="reg_draw">
        <xsl:with-param name="standalone">0</xsl:with-param>
      </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
      <xsl:apply-templates select=".//my:register[@id=$register]" mode="reg_draw">
        <xsl:with-param name="standalone">1</xsl:with-param>
      </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
  </svg>
</xsl:template>

</xsl:stylesheet>

