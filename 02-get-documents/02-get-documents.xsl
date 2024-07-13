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
  
  <!-- NOTE: If you want to write templates for the external document 
           you pull in, you have to use 
           apply-templates here, 
           not
           value-of or sequence -->
  <xsl:template match="*[contains(@class, ' map/topicref ')]">
    <xsl:comment>Figs: <xsl:number count="descendant::fig"/></xsl:comment>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="document(@href)/*[contains(@class, ' topic/topic ')]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="fig">
    <xsl:element name="fig">
<!--      <xsl:number count="fig" level="any" from="/bookmap/chapter"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&#xa;</xsl:text>-->
    

      <xsl:attribute name="att"><xsl:value-of select="../../name()"/></xsl:attribute>
    
    
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
