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

  <xsl:template match="*[contains(@class, ' map/topicref ')]">
    <xsl:comment>
      <xsl:value-of select="@navtitle"/><xsl:text>&#10;</xsl:text>
    </xsl:comment>
    <xsl:choose>
      <xsl:when test=".[contains(@class, ' bookmap/chapter ')]">
        <xsl:comment>
          <xsl:value-of select="@navtitle"/><xsl:text>&#10;</xsl:text>
        </xsl:comment>

        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="document(@href)/*[contains(@class, ' topic/topic ')]"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="document(@href)/*[contains(@class, ' topic/topic ')]"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
