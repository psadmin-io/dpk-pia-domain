$tempWebServer = loadyaml('c:\temp\hrdev.yaml')

$pia_domain_list = $tempWebServer['pia_domain_list']
$pia_domain_list.each |$domain_name, $pia_domain_info| {

  $webserver_settings = $pia_domain_info['webserver_settings']
  $webserver_settings_array  = join_keys_to_values($webserver_settings, '=')

  $config_settings = $pia_domain_info['config_settings']
  if $config_settings {
    $config_settings_array = hash_of_hash_to_array_of_array($config_settings)
  }

  $pia_site_list         = $pia_domain_info['site_list']
  $pia_site_list_array   = hash_of_hash_to_array_of_array($pia_site_list)

  pt_webserver_domain { "${domain_name}":
    ensure                => hiera('ensure'),
    ps_home_dir           => hiera('ps_home_location'),
    os_user               => hiera('domain_user'),
    ps_cfg_home_dir       => $pia_domain_info['ps_cfg_home_dir'],
    webserver_settings    => $webserver_settings_array,
    config_settings       => $config_settings_array,
    gateway_user          => $pia_domain_info['gateway_user'],
    gateway_user_pwd      => $pia_domain_info['gateway_user_pwd'],
    auth_token_domain     => $pia_domain_info['auth_token_domain'],
    site_list             => $pia_site_list_array,
  } 
}