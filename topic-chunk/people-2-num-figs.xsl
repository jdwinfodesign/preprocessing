<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="bookmap">
    <xsl:element name="bookmap">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 
  05-26-2024 Works as intended p. 268 XSLT Cookbook, 
    structure similar to map with chapters and figs.
  -->
  <xsl:template match="chapter">
    <xsl:element name="chapter">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- Using the fig template as written on p. 270 repeated 
         the position within the parent, so it was always 1. 
       https://stackoverflow.com/questions/62792615/xslt-find-position-of-node-in-a-given-nodeset
          almost works but does not limit scope to common ancestor
          
          have not tried this
          https://stackoverflow.com/questions/53347701/xslt-need-to-count-number-of-nodes-where-count-is-more-than-1-within-the-parent
  -->
  <xsl:template match="fig">
    <xsl:element name="fig">
      <xsl:variable name="chapterNo">
        <xsl:value-of select="count(ancestor::*/preceding-sibling::chapter) + 1"/>
      </xsl:variable>
      <xsl:text>fig </xsl:text>
      <xsl:value-of select="$chapterNo"/>
      <xsl:text>-</xsl:text>
      <xsl:number count="fig" level="any" from="chapter"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
