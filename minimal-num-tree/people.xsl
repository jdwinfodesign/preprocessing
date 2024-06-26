<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="text" indent="yes"/>

  <xsl:template match="people">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- 
  05-26-2024 Works as intended p. 268 XSLT Cookbook, 
    structure similar to map with chapters and figs.
  -->
  <xsl:template match="group">    
    <xsl:apply-templates/>
  </xsl:template> 
  <!-- Using the person template as written on p. 270 repeated 
         the position within the parent, so it was always 1. 
       https://stackoverflow.com/questions/62792615/xslt-find-position-of-node-in-a-given-nodeset
          does the trick, because it lets you pick the nodeset you are counting within 
          and still avoids use of xsl:nmumber
  -->
  <xsl:template match="person">
    <xsl:variable name="groupNo">
      <xsl:value-of select="count(ancestor::*/preceding-sibling::group) +1"/>
    </xsl:variable>
    <xsl:variable name="number">
      <xsl:value-of select="count(preceding::person) +1"/>
    </xsl:variable><xsl:text>Person </xsl:text>
    <xsl:value-of select="$groupNo"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$number"/><xsl:text>: </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>