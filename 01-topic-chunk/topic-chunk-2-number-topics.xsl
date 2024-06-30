<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:import href="../dita-ot-4.2/plugins/org.dita.base/xsl/common/dita-utilities.xsl"/>
  <xsl:import href="../dita-ot-4.2/plugins/org.dita.base/xsl/common/output-message.xsl"/>
  
  <xsl:variable name="msgprefix" select="''"/>
  <xsl:variable name="newline">&#10;</xsl:variable>
  
<!--  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>-->

<!-- from add-topic-numbers.xsl -->
  
  <!-- Create an easy lookup variable with the full TOC, with extra grouping elements
        like <submap> removed. -->
  <xsl:variable name="fulltoc" as="element()">
    <xsl:for-each select="/*">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates select="
          /*/*[contains(@class, ' map/topicref ')]
          [not(contains(@class, ' bookmap/appendix-reference '))]" mode="buildtoc"/>
      </xsl:copy>
    </xsl:for-each>
  </xsl:variable>
  
  <!-- If a topicref has HREF, keep a copy of it with attributes. Disregard other elements. -->
  <xsl:template match="*" mode="buildtoc">
    <xsl:choose>
      <xsl:when test="@href">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="genid" select="generate-id(.)"/>
          <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="buildtoc"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="buildtoc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:param name="topiclabel"/>
    <xsl:param name="spectopicnum"/>
    <xsl:param name="spectocid"/>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="
    *[contains(@class, ' map/topicref ')][not(contains(@class, ' bookmap/appendix-reference '))]
    [@href]
    [ancestor-or-self::*[contains(@class, ' bookmap/preface ')]]">
    <xsl:variable name="id-in-gentoc" select="generate-id(.)"/>
    <xsl:variable name="tocnum">F</xsl:variable>
    <xsl:variable name="locale">preface</xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="spectopicnum" select="$tocnum"/>
      <xsl:if test="empty(*[contains(@class, ' map/topicmeta ')])">
        <topicmeta class="- map/topicmeta " xtrf="{@xtrf}" xtrc="{@xtrc}">
          <resourceid class="- topic/resourceid " appname="locale" appid="{$locale}" xtrf="{@xtrf}"
            xtrc="{@xtrc}"/>
          <resourceid class="- topic/resourceid " appname="spectopicnum" appid="{$tocnum}"
            xtrf="{@xtrf}" xtrc="{@xtrc}"/>
          <resourceid class="- topic/resourceid " appname="spectocid" appid="{$id-in-gentoc}"
            xtrf="{@xtrf}" xtrc="{@xtrc}"/>
        </topicmeta>
      </xsl:if>
      <xsl:apply-templates select="node()">
        <xsl:with-param name="spectopicnum" select="$tocnum"/>
        <xsl:with-param name="spectocid" select="$id-in-gentoc"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="
    *[contains(@class, ' map/topicref ')][not(contains(@class, ' bookmap/appendix-reference '))]
    [@href]
    [ancestor-or-self::*[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/appendix ')]]">
    <xsl:variable name="id-in-gentoc" select="generate-id(.)"/>
    <xsl:variable name="tocnum">
      <xsl:apply-templates select="$fulltoc//*[@genid = $id-in-gentoc]" mode="find-position-in-toc"
      />
    </xsl:variable>
    <xsl:variable name="label">
      <xsl:apply-templates select="$fulltoc//*[@genid = $id-in-gentoc]" mode="define-topic-label"/>
    </xsl:variable>
    <!-- new result topicref -->
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="spectopicnum" select="$tocnum"/>
      <xsl:if test="empty(*[contains(@class, ' map/topicmeta ')])">
        <topicmeta class="- map/topicmeta " xtrf="{@xtrf}" xtrc="{@xtrc}">
          <resourceid class="- topic/resourceid " appname="spectopicnum" appid="{$tocnum}"
            xtrf="{@xtrf}" xtrc="{@xtrc}"/>
          <resourceid class="- topic/resourceid " appname="spectocid" appid="{$id-in-gentoc}"
            xtrf="{@xtrf}" xtrc="{@xtrc}"/>
          <resourceid class="- topic/resourceid " appname="topiclabel" appid="{$label}"
            xtrf="{@xtrf}" xtrc="{@xtrc}"/>
        </topicmeta>
      </xsl:if>
      <xsl:apply-templates select="node()">
        <xsl:with-param name="topiclabel" select="$label"/>
        <xsl:with-param name="spectopicnum" select="$tocnum"/>
        <xsl:with-param name="spectocid" select="$id-in-gentoc"/>
      </xsl:apply-templates>
    </xsl:copy>
    
    <xsl:if test=".[contains(@class, ' bookmap/chapter ')]">
      <xsl:comment>
          <xsl:value-of select="@navtitle"/><xsl:text>&#10;</xsl:text>
        </xsl:comment>
    </xsl:if>
    
  </xsl:template>
  
  
  
<!-- ========================== -->
<!-- ========== following is original topic-chunk xsl -->
<!--  
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
-->
  <!-- 
    /bookmap/chapter[1]/topicref[1]/topicref[1]/topicref[1]/concept[1]/conbody[1]/p[3]/fig[1]
  -->

  <!--  <xsl:template match="*[contains(@class, ' topic/fig ')]">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  -->


</xsl:stylesheet>
