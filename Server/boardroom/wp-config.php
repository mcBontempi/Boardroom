<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'db476124307');

/** MySQL database username */
define('DB_USER', 'dbo476124307');

/** MySQL database password */
define('DB_PASSWORD', 'Debb123x');

/** MySQL hostname */
define('DB_HOST', 'db476124307.db.1and1.com');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         ')^1#i]1T>,-j$2kX1VBn?S^F_gZRF<h^x=J6)u%!-C_XA+[vYuN:(EBkY-^&u+^x');
define('SECURE_AUTH_KEY',  'f1+#+V=L{Fs.tfYhd~+8tvbCBoSKvQI(ao.?-OYYqiV/Hz=z;+(mHK+Yw/R+z_#~');
define('LOGGED_IN_KEY',    'pZSTy5O-*&KTW?93Y%wiTLvCe-cEwZKi6>-~$-5,/vH;OKNLYc=VQS!h6{!,SFgl');
define('NONCE_KEY',        'd{MFny<L_W1I-F;/n~_Kt>^7P[-a<j@8#zcBZ02Lx|B|)S0poa|kP#iC@<Pj;=TU');
define('AUTH_SALT',        '7V|-G+u^St5u4Izw+Y0N_b@r:J42Wtc>=+|=|T;zX/<Y@X=PYE0}k3B-O5A# |df');
define('SECURE_AUTH_SALT', ',w$1$FHR]`kGyGntvV_1#(L4<r8%rJg^*ohQN53RYaq:b?~|x@=4GLh%0BgD]nSI');
define('LOGGED_IN_SALT',   'jI!=9s>6(hCRaD?tdIkZ*hc]_ulw`apTJ3!x|b+}L-s)YuqVK(jVqB-jq%tKgQ&(');
define('NONCE_SALT',       '}=#0 wHSF9A4-TwYux|1}l@-z9c+i6<vnbjwsM(Jw|{B]bv#6q?Dfd1HVW|[|y6R');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
