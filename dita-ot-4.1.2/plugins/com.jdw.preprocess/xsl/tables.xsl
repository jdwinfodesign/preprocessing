<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Open Toolkit project.
  See the accompanying license.txt file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
  xmlns:table="http://dita-ot.sourceforge.net/ns/201007/dita-ot/table"
  version="2.0"
  exclude-result-prefixes="xs dita-ot dita2html ditamsg table">

  <xsl:template match="*[contains(@class, ' topic/table ')]">
    <!-- ================================================ -->
    <!-- seeing what can the topic see of the map at this point -->
<xsl:message>
  map/@id
</xsl:message>    
    <!-- ================================================ -->    
    <xsl:element name="table">
      <xsl:choose>
        <xsl:when test="preceding-sibling::p[1][contains(@outputclass, 'table-title')]">
          <xsl:element name="title">
            <xsl:value-of select="preceding-sibling::p[1]"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:comment>
            <xsl:text>No preceding paragraph containing @table-title</xsl:text>
          </xsl:comment>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

<!-- 
  [A-Za-z]+\s[0-9]+\.[0-9]+-[0-9]+
  -->
  
</xsl:stylesheet>