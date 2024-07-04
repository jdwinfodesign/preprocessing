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

  <!-- This is operating on $fulltoc which has already filtered out all non-meaningful topicrefs and groups,
        like the <submap> container for referenced maps -->
  <xsl:template match="*" mode="find-position-in-toc">
    <!-- jdw 09-26-2022 Count the following siblings if they are topicrefs -->
    <xsl:variable name="following-siblings">
      <xsl:value-of select="count(following-sibling::topicref)"/>
    </xsl:variable>
    <xsl:variable name="countSelf">
      <xsl:number format="1" count="
        *[contains(@class, ' map/topicref ')]
        [not(contains(@class, ' bookmap/appendix-reference '))]"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains(@class, ' bookmap/appendix ')">
        <!--                <xsl:text>Appendix&#160;</xsl:text>-->
        <xsl:number format="A" count="*[contains(@class, ' bookmap/appendix ')]" level="any"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' bookmap/chapter ')">
        <!--                <xsl:text>Chapter&#160;</xsl:text>-->
        <xsl:number format="1" count="*[contains(@class, ' bookmap/chapter ')]" level="any"/>
      </xsl:when>
      <xsl:when test="parent::*[contains(@class, ' bookmap/appendix ')]">
        <xsl:choose>
          <xsl:when test="contains(@class, ' bookmap/exhibit ')">
            <!--                        <xsl:text>Exhibit&#160;</xsl:text>-->
            <xsl:number format="A" count="*[contains(@class, ' bookmap/appendix ')]" level="any"/>
            <xsl:text>-</xsl:text>
            <xsl:number format="1" count="*[contains(@class, ' bookmap/exhibit ')]"/>
          </xsl:when>
          <xsl:when test="contains(@class, ' bookmap/appendix-ref-num ')">
            <xsl:text>Appendix&#160;</xsl:text>
            <xsl:number format="A" count="*[contains(@class, ' bookmap/appendix ')]" level="any"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$countSelf = '1' and $following-siblings = 0">
                <xsl:apply-templates select="parent::*" mode="find-position-in-toc"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="parent::*" mode="find-position-in-toc"/>
                <xsl:text>-</xsl:text>
                <xsl:number format="1" count="
                  *[contains(@class, ' map/topicref ')]
                  [not(contains(@class, ' bookmap/appendix-reference '))]"/>
              </xsl:otherwise>
            </xsl:choose>
            <!--                        <xsl:value-of select="count(following-sibling::topicref)"/>-->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="parent::*[contains(@class, ' bookmap/chapter ')]">
        <xsl:choose>
          <xsl:when test="contains(@class, ' bookmap/exhibit ')">
            <!--                        <xsl:text>Exhibit&#160;</xsl:text>-->
            <xsl:number format="1" count="*[contains(@class, ' bookmap/chapter ')]" level="any"/>
            <xsl:text>-</xsl:text>
            <xsl:number format="1" count="*[contains(@class, ' bookmap/exhibit ')]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="parent::*" mode="find-position-in-toc"/>
            <xsl:text>-</xsl:text>
            <xsl:number format="1" count="*[contains(@class, ' map/topicref ')]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="parent::*" mode="find-position-in-toc"/>
        <xsl:text>.</xsl:text>
        <xsl:number format="1" count="*[contains(@class, ' map/topicref ')]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="define-topic-label">
    <xsl:choose>
      <xsl:when test="contains(@class, ' bookmap/appendix ')">
        <xsl:text>Appendix</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' bookmap/chapter ')">
        <xsl:text>Section</xsl:text>
      </xsl:when>
      <xsl:when test="parent::*[contains(@class, ' bookmap/chapter ')]">
        <xsl:text>Subsection</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  

</xsl:stylesheet>
