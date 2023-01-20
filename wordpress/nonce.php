<?php
/**
 * Get nonce
 *

/** WordPress Administration Bootstrap */
require_once __DIR__ . '/admin.php';

$title = 'Nonce';
$nonce = wp_create_nonce( 'wp_rest' );

echo '<form method="get">'."\n";
echo '<input type="hidden" id="_wpnonce" name="_wpnonce" value="' . $nonce .  '" />'."\n";
echo '</form>'."\n";

require_once ABSPATH . 'wp-admin/admin-footer.php';
