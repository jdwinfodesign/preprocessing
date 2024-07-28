<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
  xmlns:opentopic="www.idiominc.com/opentopic"
  xmlns:ot-placeholder="suite-sol.com/namespaces/ot-placeholder">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

<!-- 
This is the XPath for the chapter in what becomes the TOC or NAV

  /bookmap/*[namespace-uri()='http://www.idiominc.com/opentopic' and 
    local-name()='map'][1]
    /chapter[1]/@spectopicnum
  
  @spectopicnum is the chapter number

This is the XPath for the same chapter as captured in the topicmeta

  /bookmap/*[namespace-uri()='http://www.idiominc.com/opentopic' and 
    local-name()='map'][1]
      /chapter[1]/topicmeta[1]/resourceid[1]/@appid
  
  @appid is the chapter number 
  
This is the XPath for the @id of the topic referred to above
  /bookmap/concept[1]/@id

The XPath to the @id of the chapter
  /bookmap/*[namespace-uri()='http://www.idiominc.com/opentopic' and 
    local-name()='map'][1]
    /chapter[1]/@id
    
    id="unique_1"

The XPath to the @id of the referenced topic
  /bookmap/concept[1]/@id
  
  id="unique_1"
  
XPath to a fig in a p
  /bookmap/concept[1]/conbody[1]/fig[1]
-->
  

  
  <xsl:key name="id" match="*[@id]" use="@id"/>
  <xsl:key name="map-id"
    match="opentopic:map//*[@id][empty(ancestor::*[contains(@class, ' map/reltable ')])]"
    use="@id"/>
  <xsl:key name="topic-id"
    match="*[@id][contains(@class, ' topic/topic ')] |
    ot-placeholder:*[@id]"
    use="@id"/>

  <xsl:template match="*[contains(@class, ' topic/fig ')]">
  <!-- 
  /bookmap/*[namespace-uri()='http://www.idiominc.com/opentopic' and 
    local-name()='map'][1]
    /chapter[1]/@id
  -->

      
    <xsl:comment>@topicId: <xsl:value-of select="ancestor::*[contains(@class, ' topic/topic ')][1]/@id"/>
<!--      figure: <xsl:number count="fig" level="any" from="$chapterId"/> parent: <xsl:value-of select="name(..)"/>-->
    </xsl:comment>

      <xsl:apply-templates/>

  </xsl:template>

</xsl:stylesheet>
