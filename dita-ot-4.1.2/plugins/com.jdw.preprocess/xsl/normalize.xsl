<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Open Toolkit project.
  See the accompanying license.txt file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="xs ditaarch dita-ot xsi" version="2.0">
  
<!--  <xsl:import href="add-topic-numbers.xsl"/>-->
  
  <xsl:param name="output.dir.uri"/>
  
  <xsl:template match="/">
    <xsl:for-each select="job/files/file[@format = ('dita', 'ditamap')]">
      <xsl:variable name="output.uri" select="concat($output.dir.uri, @uri)"/>
      <xsl:message select="$output.uri"/>
      <xsl:message>
        <xsl:text>name: </xsl:text>
        <xsl:value-of select="./@format"/>
      </xsl:message>
      <xsl:for-each select="document(@uri, .)">
        <xsl:choose>
          <xsl:when test="*/@xsi:noNamespaceSchemaLocation">
            <xsl:result-document href="{$output.uri}">
              <xsl:apply-templates/>
            </xsl:result-document>
          </xsl:when>
          <xsl:otherwise>
            <xsl:result-document href="{$output.uri}"
              doctype-public="{dita-ot:get-doctype-public(.)}"
              doctype-system="{dita-ot:get-doctype-system(.)}">
              <xsl:apply-templates/>
            </xsl:result-document>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:function name="dita-ot:get-doctype-public">
    <xsl:param name="doc" as="document-node()"/>
    <xsl:variable name="doctypeString">urn:pubid:jdwinfodesign.com:doctypes:dita:dtd:</xsl:variable>
    <xsl:variable name="docName">
      <xsl:value-of select="name($doc)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$doc/*[contains(@class, ' bookmap/bookmap ')]">
        <xsl:text>urn:pubid:jdwinfodesign.com:doctypes:dita:dtd:bookmap</xsl:text>
      </xsl:when>
      <xsl:when test="$doc/*[contains(@class, ' topic/topic ')]">
        <xsl:text>urn:pubid:jdwinfodesign.com:doctypes:dita:dtd:topic</xsl:text>
      </xsl:when>
      <xsl:when test="$doc/*[contains(@class, ' concept/concept ')]">
        <xsl:text>urn:pubid:jdwinfodesign.com:doctypes:dita:dtd:concept</xsl:text>
      </xsl:when>
      <xsl:when test="$doc/*[contains(@class, ' task/task ')]">
        <xsl:text>urn:pubid:jdwinfodesign.com:doctypes:dita:dtd:task</xsl:text>
      </xsl:when>
      <xsl:when test="$doc/*[contains(@class, ' reference/reference ')]">
        <xsl:text>urn:pubid:jdwinfodesign.com:doctypes:dita:dtd:reference</xsl:text>
      </xsl:when>
      <xsl:when test="$doc/*[contains(@class, ' map/map ')]">
        <xsl:text>urn:pubid:jdwinfodesign.com:doctypes:dita:dtd:map</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>doctype unknown</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:function name="dita-ot:get-doctype-system">
    <xsl:param name="doc" as="document-node()"/>
    <xsl:value-of select="name($doc/*)"/>
    <xsl:text>.dtd</xsl:text>
  </xsl:function>
  <xsl:template match="@class | @domains | @xtrf | @xtrc | @ditaarch:DITAArchVersion" priority="10"/>
  <xsl:template match="
      processing-instruction('workdir') |
      processing-instruction('workdir-uri') |
      processing-instruction('path2project') |
      processing-instruction('path2project-uri') |
      processing-instruction('path2rootmap-uri') |
      processing-instruction('ditaot') |
      processing-instruction('doctype-public') |
      processing-instruction('doctype-system') |
      @dita-ot:* |
      @mapclass" priority="10"/>
  <xsl:template match="*[number(@ditaarch:DITAArchVersion) &lt; 1.3]/@cascade"/>
  <xsl:template match="*[@class]" priority="-5">
    <xsl:element name="{tokenize(tokenize(normalize-space(@class), '\s+')[last()], '/')[last()]}"
      namespace="{namespace-uri()}">
      <xsl:apply-templates select="node() | @*"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*" priority="-10">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="node() | @*"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="node() | @*" priority="-15">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  <!-- remove @specializations and @spectopicnum -->
  <!-- might be quite handy to use @spectopicnum 
       in the future, so might consider adding   -->
  <xsl:template match="@specializations | @spectopicnum"/>
  <!-- some docs used paragraphs as titles for figs and tables -->
  <xsl:template match="*[contains(@class, ' topic/p ') and @outputclass = 'table-title']"/>
</xsl:stylesheet>
