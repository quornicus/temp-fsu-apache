<VirtualHost *:80>
	# ServerName {{getv "/base/domain"}}
	DocumentRoot /var/www/html
    Errorlog /dev/stderr
	CustomLog /dev/stdout combined

	<Directory /var/www/html/>
		Require all granted
		Options FollowSymlinks
		AllowOverride all
	</Directory>

	# Apache Reverse Proxy for Islandora
	ProxyRequests Off
	ProxyPreserveHost On
	
	<Proxy *>
		AddDefaultCharset off
		Order deny,allow
		Allow from all
	</Proxy>

	AllowEncodedSlashes NoDecode
	## Fedora
	ProxyPass /fedora/get http://{{getv "/fedora/endpoint"}}:8080/fedora/get
	ProxyPassReverse /fedora/get http://{{getv "/fedora/endpoint"}}:8080/fedora/get
	ProxyPass /fedora/services http://{{getv "/fedora/endpoint"}}:8080/fedora/services
	ProxyPassReverse /fedora/services http://{{getv "/fedora/endpoint"}}:8080/fedora/services
	ProxyPass /fedora/describe http://{{getv "/fedora/endpoint"}}:8080/fedora/describe
	ProxyPassReverse /fedora/describe http://{{getv "/fedora/endpoint"}}:8080/fedora/describe
	ProxyPass /fedora/risearch http://{{getv "/fedora/endpoint"}}:8080/fedora/risearch
	ProxyPassReverse /fedora/risearch http://{{getv "/fedora/endpoint"}}:8080/fedora/risearch
	## Images
	ProxyPass /adore-djatoka http://{{getv "/image/services/endpoint"}}:8080/adore-djatoka
	ProxyPassReverse /adore-djatoka http://{{getv "/image/services/endpoint"}}:8080/adore-djatoka
	ProxyPass /iiif/2 http://{{getv "/image/services/endpoint"}}:8080/cantaloupe/iiif/2 nocanon
	ProxyPassReverse /iiif/2 http://{{getv "/image/services/endpoint"}}:8080/cantaloupe/iiif/2
	ProxyPass /cantaloupe/iiif/2 http://{{getv "/image/services/endpoint"}}:8080/cantaloupe/iiif/2 nocanon
	ProxyPassReverse /cantaloupe/iiif/2 http://{{getv "/image/services/endpoint"}}:8080/cantaloupe/iiif/2
	## New cantaloupe settings for testing April 2020
	ProxyPassReverseCookiePath /cantaloupe/iiif/2 /iiif/2
	ProxyPassReverseCookieDomain /cantaloupe/iiif/2 {{getv "/base/domain"}}
	## Use internal routing for adore-djatoka requests.
	RewriteEngine On
	RewriteCond %{QUERY_STRING} (.*)(https|http)(?:[^%]|%[0-9A-Fa-f]{2})+(%2Fislandora.*)
	RewriteRule ^/adore-djatoka/resolver /adore-djatoka/resolver?%1http://apache%3 [L,PT]

</VirtualHost>
