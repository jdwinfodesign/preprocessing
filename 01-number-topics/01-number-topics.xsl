<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!--  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>-->
  <!--  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>-->
  
  <!-- 
    THE POINT of this xsl is to provide a snapshot of the doc after it has been processed 
    at the topic-chunk target in the build file. In other words, the xml file here 
    is the same as it would be after that target. 
    
    The files in this directory are named for the target they simulate. You can keep the files 
    as they appear after the normal target by simply importing the XSL for that step 
    in the XSL in this directory. To modify the output, add your changes here. 
    
    To number the figures and other descendant elements, modify the XSL used after the metadata 
    has been moved to the topic files. 
    
    The XML in this directory simulates topic-chunk to number-topics. Import the default xsl, 
    run an XSL transform scenario using an identity template, import the XSL for the next 
    target, and add any changes. 
    
    This stage adds the spectopicnum and so on. 
    
    The move-meta target adds the same info to the topic files from the map.
    
    At that point, I think we can number the figs. 
 
  -->

  <xsl:import href="../dita-ot-4.2/plugins/com.jdwinfodesign.preprocess/xsl/number-topics.xsl"/>

  <xsl:variable name="msgprefix" select="''"/>
  <xsl:variable name="newline">&#10;</xsl:variable>

<!--  <xsl:template match="//*[contains(@class, ' map/topicref ')]">
    <xsl:apply-templates select="document(@href)/*[contains(@class, ' topic/topic ')]"/>
  </xsl:template>-->

</xsl:stylesheet>
