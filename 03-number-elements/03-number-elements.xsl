<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="msgprefix" select="''"/>
  <xsl:variable name="newline">&#10;</xsl:variable>

  <!--  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>-->
  <!--  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>-->

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="bookmap/chapter | appendix">
    <xsl:copy>
      <xsl:apply-templates select="document(descendant-or-self::*/@href)//fig"/>
    </xsl:copy>
  </xsl:template>

  <!--  
  <xsl:template match="fig">
    <xsl:apply-templates/>
  </xsl:template>
-->
  <!-- 
    <resourceid appid="Chapter" appname="topiclabel"
    <resourceid appid="d24e10" appname="spectocid"
    <resourceid appid="1" appname="spectopicnum"   
  
-->
  <!-- 
      
-->
<xsl:template match="fig">
  <xsl:element name="fig">
    <xsl:comment>
      <xsl:value-of select="ancestor::*[contains(@class, ' topic/topic ')]/@id"/>
    </xsl:comment>
    
    <xsl:text>fig </xsl:text>
    <xsl:number count="fig" level="any" from="chapter"/>
    <xsl:value-of select="@name"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:element>
</xsl:template>


</xsl:stylesheet>
