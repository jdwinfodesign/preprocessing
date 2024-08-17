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

  <xsl:template match="bookmap">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <!-- 
  05-26-2024 Works as intended p. 268 XSLT Cookbook, 
    structure similar to map with chapters and figs.
  -->
  <!-- 
  08-17-2024
    
  -->
  
  
  <xsl:template match="*[contains(@class, ' bookmap/chapter ')]">
    
    
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      
      <xsl:for-each select="descendant-or-self::*[contains(@class, ' map/topicref ')]">
        
        <xsl:apply-templates select="document(@href)/*[contains(@class, ' topic/topic ')]//fig"/>
        
      </xsl:for-each>

    </xsl:copy>
    
  </xsl:template>



  <!-- 
      <resourceid appid="1" appname="spectopicnum" class="- topic/resourceid " xtrc="chapter:1;7:53"
      xtrf="file:/C:/Users/jdwin/Documents/preprocessing/00-simple/simple.ditamap"/>
  -->

</xsl:stylesheet>
