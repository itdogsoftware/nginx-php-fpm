[www]
pm = static
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 100

user = $PHP_USER
group = $PHP_GROUP
listen = $PHP_SOCK_FILE
listen.owner = $PHP_USER
listen.group = $PHP_GROUP
listen.mode = $PHP_MODE

access.log = /dev/null
php_admin_value[error_log] = /dev/null
php_admin_flag[log_errors] = off
php_admin_value[expose_php] = Off
