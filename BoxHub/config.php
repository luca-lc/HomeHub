<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/boxapps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => false,
    ),
  ),
  'instanceid' => 'ocu7e04ylan6',
  'passwordsalt' => 'nbzRsAw8DPw4ilizztFiwLx0wEj8mX',
  'secret' => 'fRQi2/0jQziIAmZ3nN2winMtpW+rVjnAro0QTOFrMkAtg3js',
  'trusted_domains' => 
  array (
    0 => 'localhost:8082',
    1 => '*.homehub_frontend',
    2 => 'localhost',
  ),
  'datadirectory' => '/var/www/html/files',
  'dbtype' => 'mysql',
  'version' => '20.0.5.2',
  'overwrite.cli.url' => 'https://localhost/boxhub',
  'dbname' => '_hbox_',
  'dbhost' => 'homehub_sql_1',
  'dbport' => '3306',
  'dbtableprefix' => '[hb]:',
  'mysql.utf8mb4' => true,
  'dbuser' => 'u[box]',
  'dbpassword' => 'u{zO[6HqVl7I[-y{t6stiF05KFW1H[FKkZETg-ef',
  'installed' => false,
  'default_language' => 'it',
  'allow_user_to_change_display_name' => true,
  'remember_login_cookie_lifetime' => 60*60*24*7, //7 days cookie lifetime
  'session_lifetime' => 60 * 60 * 24, //the lifetime of a session after inactivity
  'auto_logout' => true, //automatic logout after session_lifetime
  'skeletondirectory' => '', //default file  at building time
  'lost_password_link' => 'disabled', //reset password for read only user
  'overwriteprotocol' => '',
  'overwritewebroot' => '/boxhub/',
  'overwritehost' => '',
  'appcodechecker' => true,
  'config_is_read_only' => true,
  'log_type' => 'syslog',
);
