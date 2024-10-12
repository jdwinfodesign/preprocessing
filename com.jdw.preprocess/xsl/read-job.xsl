<?xml version="1.0" encoding="UTF-8"?>
<!--
    Generate a topic number for each title in the TOC.
    Makes several assumptions:
    * Assumes input is bookmap
    * Assumes uses chapters and appendix (not part)
    * Assumes submap boundaries are not important
    * Assumes every numbered heading has a topic (would not number topicheads)
    -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
  <xsl:variable name="msgprefix" select="''"/>
  <xsl:variable name="newline">&#10;</xsl:variable>

  <xsl:param name="args.input"/>

  <xsl:template match="/">
    <xsl:variable name="mainMap">
      <xsl:value-of select="tokenize($args.input, '\\')[last()]"/>
    </xsl:variable>
    <xsl:variable name="hashMap">
      <xsl:value-of select="//file[contains(@src, $mainMap)]/@uri"/>
    </xsl:variable>
    <job>
      <mainMap>
        <xsl:value-of select="$mainMap"/>
      </mainMap>
      <hashMap>
        <xsl:value-of select="$hashMap"/>
      </hashMap>
    </job>
  </xsl:template>

</xsl:stylesheet>
