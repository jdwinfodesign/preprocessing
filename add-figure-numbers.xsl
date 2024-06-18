<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="xs ditaarch dita-ot xsi" version="3.0">
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:message>----- root template begins -----</xsl:message>
    <xsl:message><xsl:value-of select="name(./*[1])"/></xsl:message>
    <xsl:value-of select="name(./*[1])"/>
    <xsl:message>-----  root template ends  -----</xsl:message>
  </xsl:template>
  
<!--  <xsl:template match="chapter[1]">
    <xsl:message><xsl:value-of select="@class"/></xsl:message>
    <xsl:message><xsl:value-of select="@href"/></xsl:message>
    
    <xsl:for-each select="//topicref">
      <xsl:message>
        <xsl:sequence select="document(@href)"/>
      </xsl:message>
    </xsl:for-each>
    
    <xsl:apply-templates/>
  </xsl:template>
  -->

</xsl:stylesheet>