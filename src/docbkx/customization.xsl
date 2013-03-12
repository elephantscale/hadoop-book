<?xml version="1.0"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
  version="1.0">

<!--
/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
-->

<!--
see : http://www.sagehill.net/docbookxsl/HTMLHeaders.html

user.header.navigation : 	Called before standard navigational header.
header.navigation : 	The standard navigational header.
user.header.content : 	Called after standard navigational header but before any other content.
user.footer.content : 	Called after the chunk content but before the standard navigational footer.
footer.navigation : 	The standard navigational footer.
user.footer.navigation : 	Called after the standard navigational footer.
-->
	

  <xsl:import href="urn:docbkx:stylesheet"/>
  <xsl:output method="html" encoding="UTF-8" indent="no"/>
 

	<xsl:template name="header.navigation">
	  <xsl:param name="prev" select="/foo"/>
	  <xsl:param name="next" select="/foo"/>
	  <xsl:param name="nav.context"/>

	  <xsl:variable name="home" select="/*[1]"/>
	  <xsl:variable name="up" select="parent::*"/>

	  <xsl:if test="$suppress.navigation = '0' and $suppress.header.navigation = '0'">
		<div class="navheader">
			<table width="100%" summary="Navigation header">
				<tr>
				  <td width="10%" align="{$direction.align.start}">
					<xsl:if test="count($prev)>0">
					  <a accesskey="p">
						<xsl:attribute name="href">
						  <xsl:call-template name="href.target">
							<xsl:with-param name="object" select="$prev"/>
						  </xsl:call-template>
						</xsl:attribute>
						<img alt="Prev" src="images/prev.png"/>
					  </a>
					</xsl:if>
					<xsl:text>&#160;</xsl:text>
				  </td>
				  <th width="80%" align="center">
					<xsl:call-template name="breadcrumbs"/>
				  </th>
				  <td width="10%" align="{$direction.align.end}">
					<xsl:text>&#160;</xsl:text>
					<xsl:if test="count($next)>0">
					  <a accesskey="n">
						<xsl:attribute name="href">
						  <xsl:call-template name="href.target">
							<xsl:with-param name="object" select="$next"/>
						  </xsl:call-template>
						</xsl:attribute>
						<img alt="Next" src="images/next.png"/>
					  </a>
					</xsl:if>
				  </td>
				</tr>
			</table>

		  <xsl:if test="$header.rule != 0">
			<hr/>
		  </xsl:if>
		  
		  <div>
			  <form action="http://www.google.com/search" method="get">
				<input type="text" value="" maxlength="255" size="31" name="q"/>
				<input type="submit" value="Google Search"/>
				<input type="radio" value="" name="sitesearch"/>
				The Web
				<input type="radio" checked="checked" value="hadoopilluminated.com" name="sitesearch"/>
				Hadoop Illuminated
				<br/>
			  </form>
		  </div>
		  
		</div>
	  </xsl:if>
	</xsl:template>

  <xsl:template name="breadcrumbs">
      <xsl:param name="this.node" select="."/>
      <div class="breadcrumbs">
          <xsl:for-each select="$this.node/ancestor::*">
              <span class="breadcrumb-link">
                  <a>
                      <xsl:attribute name="href">
                          <xsl:call-template name="href.target">
                              <xsl:with-param name="object" select="."/>
                              <xsl:with-param name="context" select="$this.node"/>
                          </xsl:call-template>
                      </xsl:attribute>
                      <xsl:apply-templates select="." mode="title.markup"/>
                  </a>
              </span>
              <xsl:text> &gt; </xsl:text>
          </xsl:for-each>
          <!-- And display the current node, but not as a link -->
          <span class="breadcrumb-node">
              <xsl:apply-templates select="$this.node" mode="title.markup"/>
          </span>
      </div>
  </xsl:template>

<!--
  <xsl:template name="header.navigation">
    hello
  </xsl:template>
-->

  <xsl:template name="user.header.navigation">
    <a href="/"><div class="logo"></div></a>
  </xsl:template>

  <xsl:template name="user.footer.content">
      <hr/>
      <span style="float: center; color: darkgrey;">
              Want to be notified when the book is updated?  Please join the discussion @ <a href="http://groups.google.com/group/hadoop-illuminated">Hadoop illuminated Google group</a>
      </span>
  </xsl:template>

  <xsl:template name="user.footer.navigation">
      <!-- google analytics -->
    <script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-38683425-1']);
    _gaq.push(['_trackPageview']);

    (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();

    </script>
  </xsl:template>

	<xsl:template name="head.content">
	  <xsl:param name="node" select="."/>
	  <xsl:param name="title">
		<xsl:apply-templates select="$node" mode="object.title.html.markup.textonly"/>
	  </xsl:param>

	  <title>
		<xsl:value-of select="$title"/> :: Hadoop Illuminated
	  </title>

	  <xsl:if test="$html.base != ''">
		<base href="{$html.base}"/>
	  </xsl:if>

	  <!-- Insert links to CSS files or insert literal style elements -->
	  <xsl:call-template name="generate.css"/>

	  <xsl:if test="$html.stylesheet != ''">
		<xsl:call-template name="output.html.stylesheets">
		  <xsl:with-param name="stylesheets" select="normalize-space($html.stylesheet)"/>
		</xsl:call-template>
	  </xsl:if>

	  <xsl:if test="$link.mailto.url != ''">
		<link rev="made" href="{$link.mailto.url}"/>
	  </xsl:if>

	  <meta name="generator" content="DocBook {$DistroTitle} V{$VERSION}"/>

	  <xsl:if test="$generate.meta.abstract != 0">
		<xsl:variable name="info" select="(articleinfo                                       |bookinfo                                       |prefaceinfo                                       |chapterinfo                                       |appendixinfo                                       |sectioninfo                                       |sect1info                                       |sect2info                                       |sect3info                                       |sect4info                                       |sect5info                                       |referenceinfo                                       |refentryinfo                                       |partinfo                                       |info                                       |docinfo)[1]"/>
		<xsl:if test="$info and $info/abstract">
		  <meta name="description">
			<xsl:attribute name="content">
			  <xsl:for-each select="$info/abstract[1]/*">
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:if test="position() &lt; last()">
				  <xsl:text> </xsl:text>
				</xsl:if>
			  </xsl:for-each>
			</xsl:attribute>
		  </meta>
		</xsl:if>
	  </xsl:if>

	  <xsl:if test="($draft.mode = 'yes' or                 ($draft.mode = 'maybe' and                 ancestor-or-self::*[@status][1]/@status = 'draft'))                 and $draft.watermark.image != ''">
		<style type="text/css"><xsl:text>
	body { background-image: url('</xsl:text>
	<xsl:value-of select="$draft.watermark.image"/><xsl:text>');
		   background-repeat: no-repeat;
		   background-position: top left;
		   /* The following properties make the watermark "fixed" on the page. */
		   /* I think that's just a bit too distracting for the reader... */
		   /* background-attachment: fixed; */
		   /* background-position: center center; */
		 }</xsl:text>
		</style>
	  </xsl:if>
	  <xsl:apply-templates select="." mode="head.keywords.content"/>
	</xsl:template>

	<xsl:template match="*" mode="object.title.html.markup.textonly">
	  <xsl:variable name="title">
		<xsl:apply-templates select="." mode="object.title.html.markup"/>
	  </xsl:variable>
	  <xsl:value-of select="normalize-space($title)"/>
	</xsl:template>
	
	<xsl:template match="*" mode="object.title.html.markup">
	  <xsl:param name="allow-anchors" select="0"/>
	  <xsl:variable name="template" select="'%t'"/>
	  
	  <xsl:call-template name="substitute-markup">
		<xsl:with-param name="allow-anchors" select="$allow-anchors"/>
		<xsl:with-param name="template" select="$template"/>
	  </xsl:call-template>
	</xsl:template>	
 
<!--	<xsl:param name="local.l10n.xml" select="document('')"/>
	<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
		<l:l10n language="en">
			<l:context name="title-numbered"> 
				<l:template name="chapter" text="%t"/> 
			</l:context>    
		</l:l10n>
	</l:i18n> -->
</xsl:stylesheet>
