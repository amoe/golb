<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">
<!-- Although XML will be chosen since the result tree has a non-null
     namespace, we declare it for clarity and to emphasize this is NOT
     HTML 4.0. -->
<xsl:output method="xml"
            indent="yes"
            doctype-public="-//W3C//DTD XHTML 1.1//EN"
            doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>
<xsl:template match="/entry">
<html>
  <head>
    <title>Read post</title>
    <link rel="stylesheet" href="golb.css" type="text/css"/>
  </head>
  <body>
    <h1>Read post</h1>
    <p>Showing the post below.</p>

    <div class="entry">
    <xsl:apply-templates select="node()"/>
    </div>

    <p>Move <a href="http://en.wikipedia.org/">on</a>.</p>
  </body>
</html>
</xsl:template>

<!-- These templates are like copy-of but applying the XHTML namespace.
     They are somewhat dark magic, but vaguely understandable.
     I got them from:
     http://www.biglist.com/lists/xsl-list/archives/200312/msg00977.html -->
<xsl:template match="node()">
  <xsl:element name="{local-name()}"
               namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*|node()|text()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*|text()">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
