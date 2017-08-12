node default {

  $instanceclass = hiera_array(classes)
  notice("On node ${::fqdn} with role ${instanceclass}.")

  hiera_include('classes','::examplerole::basics')
  
}
