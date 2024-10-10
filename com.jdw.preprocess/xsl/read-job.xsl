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
  <!-- 
  C:\Users\jdwin\Documents\preprocessing\05-add-fig-numbers\simple.ditamap
  -->

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:comment>
      <xsl:value-of select="$args.input"/>
    </xsl:comment>
    <foo>
      <p>
        <xsl:value-of select="$args.input"/>
      </p>
      <p>
        <xsl:value-of select="tokenize($args.input, '\\')[last()]"/>
      </p>
    </foo>
  </xsl:template>

  <!-- 
  C:\xml\inwork\bookmap\preview\lessonName
  
  To get 'lessonName' tried using 
   
  <substring-after($filePath, '/')[last[])"/>             and 
  <substring-after((tokenize($filePath, '/')[last[])"/> 
  
  Tokenize the path based on the separator '\', which must be escaped with a second '\'
  
  <xsl:value-of select="tokenize($filePath, '\\')[last()]"/>
  
  -->

</xsl:stylesheet>
