<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Move generated topic numbers into the title / navigation title for
    each topic and TOC entry.
    
    Assumes that an earlier step has generated <resourceid> elements
    for the numbering.
    -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
    <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>

    <xsl:variable name="newline"><xsl:text>
</xsl:text>
    </xsl:variable>

    <xsl:variable name="msgprefix" select="''"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Match <navtitle> or <linktext> inside of <topicmeta>.
        If there is a generated resourceid with a TOC number, copy that TOC number
        before the navigation title or link text. -->
    <xsl:template match="
        *[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]
        [ancestor-or-self::*[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/appendix ')]]|
        *[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/navtitle ')]
        [ancestor-or-self::*[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/appendix ')]]|
        *[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/linktext ')]
        [ancestor-or-self::*[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/appendix ')]]|
        *[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]
        [ancestor-or-self::*[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/appendix ')]]">
        <xsl:variable name="topiclabel" select="../resourceid[@appname = 'topiclabel']/@appid" />
        <xsl:variable name="spectopicnum" select="../resourceid[@appname = 'spectopicnum']/@appid" />

        <!-- 
            /bookmap/appendix[1]/appendix-reference[1]
            /bookmap/appendix[1]/exhibit[1]
        -->

        <xsl:choose>
            <xsl:when test="$spectopicnum and $topiclabel!=''">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:value-of
                        select="concat($topiclabel, ' ', $spectopicnum, ' ')"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$spectopicnum and $topiclabel=''">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:value-of
                        select="concat($spectopicnum, ' ')"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Match a topic title; assumes root topic (does not work with <dita>).
        If there is a generated resourceid with a TOC number, copy that TOC number
        before the title text. -->
    <xsl:template match="/*[contains(@class, ' topic/topic ')]/*[contains(@class,' topic/title ')]">
        <!-- Verify that the topic is or is not a preface topic so that it doesn't add any prefix to the title of the topic -->
        <xsl:variable name="isPreface">
            <xsl:choose>
                <xsl:when test="../*[contains(@class,' topic/prolog ')]/resourceid[@appid='preface']">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="topiclabel" select="../*[contains(@class,' topic/prolog ')]/resourceid[@appname = 'topiclabel']/@appid" />
        <xsl:variable name="spectopicnum" select="../*[contains(@class,' topic/prolog ')]/resourceid[@appname='spectopicnum']/@appid"/>
        <xsl:message>
            <xsl:text>topiclabel: </xsl:text>
            <xsl:value-of select="$topiclabel"/>
            <xsl:value-of select="$newline"/>
            <xsl:text>spectopicnum: </xsl:text>
            <xsl:value-of select="$spectopicnum"/>
            <xsl:value-of select="$newline"/>
        </xsl:message>
        <xsl:choose>
            <xsl:when test="$spectopicnum and $topiclabel!='' and $isPreface='false'">
                <xsl:message>first match</xsl:message>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:value-of select="concat($topiclabel, ' ', $spectopicnum, ' ')"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$spectopicnum and $topiclabel='' and $isPreface='false'">
                <xsl:message>second match</xsl:message>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:value-of select="concat($spectopicnum, ' ')"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Match a navigation title in a topic; assumes root topic (does not work with <dita>).
        If there is a generated resourceid with a TOC number, copy that TOC number
        before the title text. -->
    <xsl:template match="/*/*[contains(@class, ' topic/titlealts ')]/*[contains(@class, ' topic/navtitle ')]">
        <xsl:choose>
            <xsl:when
                test="../../*[contains(@class, ' topic/prolog ')]/resourceid[@appname = 'spectopicnum']">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:value-of
                        select="concat(../../*[contains(@class, ' topic/prolog ')]/resourceid[@appname = 'spectopicnum']/@appid, ' ')"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Strip out the generated topic number, which is no longer needed after this step. -->
    <!--    <xsl:template match="resourceid[@appname = 'spectopicnum']"/>-->

</xsl:stylesheet>
