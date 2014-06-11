class svn_windows (
    $version     = $svn_windows::params::version,
    $url         = $svn_windows::params::url,
    $package     = $svn_windows::params::package,
    $file_path   = false,
) inherits svn_windows::params {
    if $file_path {
        $svn_installer_path = $file_path
    } else {
        $svn_installer_path = "${::temp}\\${package}-${version}.msi"
    }
    windows_common::remote_file{'svn':
        source      => $url,
        destination => $svn_installer_path,
        before      => Package[$package],
    }
        
    package { $package:
        ensure          => installed,
        source          => $svn_installer_path,
        install_options => ['/quiet'],
    }

    $svn_path = 'C:\\Program Files (x86)\\SlikSvn\\bin'
 
    windows_path { $svn_path:
        ensure  => present,
        require => Package[$package],
    }
}
