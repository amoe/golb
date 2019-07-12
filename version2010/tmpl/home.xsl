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
<xsl:template match="/">
<html>
  <head>
    <title>Home page</title>
    <link rel="stylesheet" href="golb.css" type="text/css"/>
  </head>
  <body>
    <h1>Home page</h1>
    <p>Showing the first 2 posts below</p>

    <xsl:for-each select="/array/object">
      <p>Post #<xsl:value-of select="id"/>:
      <!-- Nice, but a hack.  See 
        http://www.dpawson.co.uk/xsl/sect2/N2215.html -->
      <xsl:value-of select="post" disable-output-escaping="yes"/></p>
    </xsl:for-each>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
