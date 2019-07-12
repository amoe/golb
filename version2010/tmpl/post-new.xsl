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
    <title>Add new post</title>
    <link rel="stylesheet" type="text/css" href="golb.css"/>
  </head>
  <body>
    <p>Please type in your post below.</p>

    <form action="post-submit.scm" method="post">
      <textarea rows="25" cols="80" name="body"/>
      <input type="submit"/>
    </form>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
