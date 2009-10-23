<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Conforming XHTML 1.1 Template</title>
    </head>
    <body>
      <h1>Read entries</h1>
      
      <p>All entries are shown below.</p>

      <xsl:for-each select="/entries/entry">
        <blockquote>
          <xsl:value-of select="."/>
        </blockquote>
      </xsl:for-each>
    </body>
  </html>
</xsl:template>
</xsl:stylesheet>
