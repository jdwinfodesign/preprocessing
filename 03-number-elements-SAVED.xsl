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
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- NOTE: If you want to write templates for the external document 
           you pull in, you have to use 
           apply-templates here, 
           not
           value-of or sequence 
           
           This rule only transforms the top-level topicrefs anyway, so why not 
           take advantage of that and write it so that it gets chapters | appendixes?
           
           And then does what?
    -->

  <!-- 
  
  /concept/conbody[1]/fig[1]
  /concept/prolog[1]/resourceid[3]/@appname
  
  [not(contains(@class, ' bookmap/chapter '))]
  -->


</xsl:stylesheet>
