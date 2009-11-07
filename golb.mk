webroot = /var/plt-web-server

host = localhost
port = 8080
refresh_url = conf/refresh-servlets

obj = golb.scm static.scm skeleton.xhtml create.scm create.xhtml create.xsl \
      confirm.xsl read.scm read.xsl delete.scm config.scm db-demo.scm \
      plain-mainpage.scm

all: install refresh_servlets

install:
	cp $(obj) $(webroot)

install_schema:
	mysql -u golb --password=golb golb < model/schema.sql

refresh_servlets:
	curl -sS -o /dev/null http://$(host):$(port)/$(refresh_url)
