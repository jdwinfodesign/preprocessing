<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!--  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>-->
  <!--  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>-->

  <xsl:import href="../dita-ot-4.2/plugins/com.jdwinfodesign.preprocess/xsl/number-topics.xsl"/>

  <xsl:variable name="msgprefix" select="''"/>
  <xsl:variable name="newline">&#10;</xsl:variable>

<!--  <xsl:template match="//*[contains(@class, ' map/topicref ')]">
    <xsl:apply-templates select="document(@href)/*[contains(@class, ' topic/topic ')]"/>
  </xsl:template>-->

</xsl:stylesheet>
