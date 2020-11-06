user $NGINX_USER;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
}

http {

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_disable "msie6";

    include /etc/nginx/conf.d/*.conf;
    #include /etc/nginx/sites-enabled/*;

    server {
        listen 80  default_server;
        root $NGINX_WEB_ROOT;

        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ $NGINX_PHP_FALLBACK?$query_string;
        }
        location ~* $NGINX_PHP_LOCATION$ {
            # CORS Rules Start #
    	    add_header Access-Control-Allow-Origin *;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, OPTIONS, DELETE';
            add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range,Authorization';
            # CORS Rules End #
            fastcgi_pass unix:$PHP_SOCK_FILE;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            include /etc/nginx/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;

            internal;
        }

        # return 404 for all other php files not matching the front controller
        # this prevents access to other php files you don't want to be accessible.
        location ~ \.php$ {
            return 404;
        }
    }
}
