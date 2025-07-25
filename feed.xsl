<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title><xsl:value-of select="/rss/channel/title"/> RSS Feed</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
        <meta charset="UTF-8"/>
        <link rel="stylesheet" href="/feed.css"/>
      </head>
      <body>
        <header>
          <h1><xsl:value-of select="/rss/channel/title"/></h1>
          <div class="aboutfeeds">
            <p>This is a web feed that can be viewed in the browser. <strong>Subscribe for free</strong> by copying the URL <code><mark>unixwinbsd.site/feed.xml</mark></code> into your RSS reader. If you need to know more, read <a href="https://www.thisdaysportion.com/about/what-is-rss/">this article by UnixBSDShell's Blog</a>.</p>
            <p>Read how <a href="https://unixwinbsd.site">I made this feed <strong>human-readable</strong></a>.</p>
          </div>
          <div class="head">
            <div class="avatar">
              <img src="/assets/images/minutes-to-midnight-portrait.jpg" alt="Portrait of UnixBSDShell's Blog, aka Minutes to Midnight" width="120" height="120" />
            </div>
            <div class="description">
              <p><xsl:value-of select="/rss/channel/description"/></p>
              <p><a hreflang="en"><xsl:attribute name="href"><xsl:value-of select="/rss/channel/link"/></xsl:attribute><strong>Visit the website</strong> &#x2192;</a></p>
            </div>
          </div>
        </header>
        <main>
          <h2><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 455.731 455.731" xml:space="preserve"><path style="fill:#f78422" d="M0 0h455.731v455.731H0z"/><path style="fill:#fff" d="M296.208 159.16C234.445 97.397 152.266 63.382 64.81 63.382v64.348c70.268 0 136.288 27.321 185.898 76.931 49.609 49.61 76.931 115.63 76.931 185.898h64.348c-.001-87.456-34.016-169.636-95.779-231.399z"/><path style="fill:#fff" d="M64.143 172.273v64.348c84.881 0 153.938 69.056 153.938 153.939h64.348c0-120.364-97.922-218.287-218.286-218.287z"/><circle style="fill:#fff" cx="109.833" cy="346.26" r="46.088"/></svg> Latest 20 posts</h2>
          <xsl:for-each select="/rss/channel/item">
            <article>
              <h3><a hreflang="en"><xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute><xsl:value-of select="title"/></a></h3>
              <footer>Published: <time><xsl:value-of select="pubDate" /></time></footer>
            </article>
          </xsl:for-each>
        </main>
        <footer>
          <p>© 2002-2024 <a href="/">UnixBSDShell's Blog</a>. Blog posts are licensed under a <a href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 license</a>. The text copy can be used, including commercially, provided that a proper attribution to me is given, including a link to <code>unixwinbsd.site</code>.</p>
        </footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
