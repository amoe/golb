<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Conforming XHTML 1.1 Template</title>
    </head>
    <body>
      <h1>Create entry</h1>
      
      <p>Feel free to type your text below.  You're the boss!</p>

      <p>I will post to: <xsl:value-of select="/k-url"/></p>
      
      <form>
        <xsl:attribute name="action">
          <xsl:value-of select="/k-url"/>
        </xsl:attribute>
        <textarea name="body" rows="25" cols="80"/>
        <input type="submit" value="Create"/>
      </form>
      
    </body>
  </html>
</xsl:template>
</xsl:stylesheet>
