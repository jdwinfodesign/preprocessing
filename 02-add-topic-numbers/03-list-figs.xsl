<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
  <xsl:variable name="msgprefix" select="''"/>
  <xsl:variable name="newline">&#10;</xsl:variable>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="chapter">
    <chapter>
      <xsl:for-each select="descendant-or-self::*[contains(@class, ' map/topicref ')]">
        <xsl:apply-templates select="document(@href)//fig"/>
      </xsl:for-each>
    </chapter>
  </xsl:template>

  <xsl:template match="fig">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
