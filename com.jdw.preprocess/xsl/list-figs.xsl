<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
  <xsl:variable name="msgprefix" select="''"/>
  <xsl:variable name="newline">&#10;</xsl:variable>
  
  <xsl:param name="args.input"/>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="chapter">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="descendant-or-self::*[contains(@class, ' map/topicref ')]">
        <xsl:apply-templates select="document(@href)//fig"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="fig">
    <!-- how to use temp dir as var -->
    <xsl:variable name="mainMap">
      <xsl:value-of select="tokenize($args.input, '\\')[last()]"/>
    </xsl:variable>
    <xsl:variable name="hashMap">
      <xsl:value-of select="//file[contains(@src, $mainMap)]/@uri"/>
    </xsl:variable>
    <xsl:comment>
      <xsl:text>mainMap: </xsl:text><xsl:value-of select="$mainMap"/>
    </xsl:comment>
    <xsl:comment>
      <xsl:text>hashMap: </xsl:text><xsl:value-of select="$hashMap"/>
    </xsl:comment>
    <!-- ========================== -->
    <xsl:message>
      <xsl:value-of select=""/>
    </xsl:message>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
