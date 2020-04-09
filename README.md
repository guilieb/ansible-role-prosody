# `ansible-role-prosody`: install prosody server

This project has been initiated by [Sébastien Gendre](mailto:s.gendre@openmailbox.org) and forked by [Guillaume Bernard](https://gitlab.com/guilieb).

This [Ansible](https://www.ansible.com) role aims at installing the [Prosody](https://prosody.im) [XMPP](https://xmpp.org/) server on multiple operating system (Debian and RHEL based).

If includes tasks that handle:
 1. Prosody installation from the distribution repositories (that requires the `epel` repository on CentOS, which is installed in this role).
 2. The definition of many `prosody` settings, including:
    - The server administrators.
    - The use of `libevent`.
    - Definition of modules.
    - Registration.
    - TLS.
    - `c2s` and `s2s` behavior.
    - Log files destination.
    - …
 3. For each domain to be managed by Prosody, this role allows to push one config file to targeted systems. Each config file includes all the settings for one domain. See an exemple in `files/prosodyexemple.com.cfg.lua`.


## Requirements

This roles does not depend on any other one. It requires to be **root** (or to become) in order to proceed.

It is assumed to work on the following GNU/Linux distributions:
 - Fedora
 - CentOS (tested on 7)
 - Red Hat (maybe, not tested)
 - Debian (tested on Debian 8.0)
 - Ubuntu

## Important

Actually, `lua-zlib` is **not available** on Red Hat familly systems repositories. And `lua-event` is **not available** on CentOS and Red Hat distributions repositories.

## Role Variables

### Installation options

 - `prosody_install_community_modules: true`: whether to install all community modules for prosody.
 - `prosody_install_lua_zlib: false`: whether to install `lua-zlib`.
 - `prosody_install_lua_event: false`: whether to install `lua-even`.
 - `prosody_install_lua_ldap: true`: whether to install `lua-ldap`. Needed by the LDAP authentication module.

### Main options
 - `prosody_admins: []`: Jabber IDs considered as Prosody administrators (ex: test@exemple.com).
 - `prosody_use_libevent: false`: whether to use `luaevent`. (Note: Requires installing `lua-event`).
 - `prosody_allow_registration: false`: whether to allow new users registration publicly, from XMPP protocol.
 - `prosody_modules_enable_default: true`: whether to enable all defaults modules. See below for the list of default modules.
 - `prosody_modules_enabled: […]`: the list of enabled modules. Added to default list if `prosody_modules_enable_default: true`.
 - `prosody_modules_disabled: []`: the list of auto-loaded modules to disable. See below for the list.

### SSL/TLS options
 - `prosody_ssl_key: "certs/localhost.key"`: the main SSL key used by Prosody. Relative to Prosody the config directory.
 - `prosody_ssl_cert: "certs/localhost.cert"`: the main SSL cert used by Prosody. Relative to Prosody the config directory.
 - `prosody_ssl_protocol`: the [protocol](https://prosody.im/doc/advanced_ssl_config#protocol) version to support. This is **undefined** by default.

### Network options
 - `prosody_c2s_ports: []`: the ports on which to listen for client connections. Leave empty for default ports.
 - `prosody_c2s_interfaces: []`: the interfaces on which to listen for client connections. Leave empty for default interfaces.
 - `prosody_c2s_timeout: null`: the timeout unauthenticated client connections. Leave `null` for default timeout.
 - `prosody_s2s_ports: []`: the ports on which to listen for server-to-server connections. Leave empty for default ports.
 - `prosody_s2s_interfaces: []`: the interfaces on which to listen for server-to-server connections. Leave empty for default ports.
 - `prosody_s2s_timeout: null`: the timeout unauthenticated server-to-server connections.Leave `null` for default timeout.

### Internal auth opitons
 - `prosody_authentication: "internal_plain"`: the backend used for user authenticacion. With `pam` or `ldap` options, this role automatically enables the required community modules. In this case, `prosody_install_community_modules: true` is needed. For `ldap` options, you need `prosody_install_lua_ldap: true` option.
 - `prosody_ldap_base: ""`: the LDAP base directory which stores user accounts.
 - `prosody_ldap_server: "localhost"`: the space-separated list of hostnames or IPs, optionally with port numbers (e.g. `localhost:8389`).
 - `prosody_ldap_rootdn: ""`: the distinguished name to auth against.
 - `prosody_ldap_password: ""`: the `rootdn` password.
 - `prosody_ldap_filter: "(uid=$user)"`: the search filter, with `$user` and `$host` substituded for user and hostname.
 - `prosody_ldap_scope: "subtree"`: the search scope. other values: `base` and `onelevel`.
 - `prosody_ldap_tls: false`: whether to enable TLS to connect to LDAP (can be `true` or `false`). The non-standard `LDAPS` protocol is not supported.
 - `prosody_ldap_mode: "bind"`: how passwords are validated. `"bind"` or `"getpasswd"`.
 - `prosody_ldap_admins: ""`: the search filter to match admins, works like `ldap_scope`.

**Note**: You can specify those LDAP options for each domain managed by Prosody, inside the domain specific files. See [Domains managed by Prosody options](#domains-managed-by-prosody-options) subsection in options section.

### Storage option
 - `prosody_data_path: "/var/lib/prosody"`: the location of the Prosody data storage directory, without any trailing slash.
 - `prosody_storage: "internal"`: the type of storage for prosody. Up to now, this role only supports `sqlite` and `internal`.

### c2s and s2s behavior options
 - `prosody_c2s_require_encryption: true`: whether to force XMPP clients to use encrypted connections.
 - `prosody_s2s_secure_auth: false`: whether to force certificate authentication for server-to-server connections.
 - `prosody_s2s_insecure_allowed_domains: [ ]`: the domains to which you allow server-to-server insecure connections*.
 - `prosody_s2s_secure_required_domains: [ "jabber.org" ]`: the domains to which you allow only secure server-to-server connections*.

**Note**: a secure connection is when the full TLS conection is validated, with updated, signed and appropriate certificates.

### Log files options
 - `prosody_log_info_level: info`: the log level: `debug` > `info` > `warn` > `error`.
 - `prosody_log_info_destination: "/var/log/prosody/prosody.log"`: the logfile destination on the targeted system
 - `prosody_log_error_destination: "/var/log/prosody/prosody.err"`: the error logfile destination on the targeted system

### Domains managed by Prosody options
 - `prosody_domains: []` List of domains (host) managed by Prosody.

For each domain, please write a config file in your `files/prosody`. The config file must be named `<domain>.cfg.lua`, where `<domain>` is one of the value registered in `prosody_domains`. For exemple: For `mydomain.org`, the corresponding config file is `mydomain.org.cfg.lua`.

For an exemple of a domain config file, see `files/prosody/exemple.com.cfg.lua` in this role directory.

### List of official modules enabled by default

This list is up-to-date according to `prosody` version `0.11.4`.

* General required:
  - `roster`: Allow users to have a roster. Recommended.
  - `saslauth`: Authentication for clients and servers. Recommended if you want to log in.
  - `tls`: Add support for secure TLS on c2s/s2s connections.
  - `dialback`: s2s dialback support.
  - `disco`: Service discovery.

* Not essential, but recommended:
  - `carbons`: Keep multiple clients in sync
  - `pep`: Enables users to publish their avatar, mood, activity, playing music and more
  - `private`: Private XML storage (for room bookmarks, etc.).
  - `blocklist`: Allow users to block communications with other users
  - `vcard4`: User profiles (stored in PEP)
  - `vcard_legacy`: Conversion between legacy vCard and PEP Avatar, vcard

* Nice to have:
  - `version`: Replies to server version requests
  - `uptime`: Report how long server has been running.
  - `time`: Let others know the time here on this server
  - `ping`: Replies to XMPP pings with pongs
  - `register`: Allow users to register on this server using a client and change passwords

* Admin interfaces:
  - `admin_adhoc`: Allows administration via an XMPP client that supports ad-hoc commands

### List of official modules not enabled by default

This list is up-to-date according to `prosody` version `0.11.4`.

* Nice to have:
  - `mam`: Store messages in an archive and allow users to access it
  - `csi_simple`: Simple Mobile optimizations

* Admin interfaces:
  - `admin_telnet`: Opens telnet console interface on localhost port 5582.

* HTTP modules:
  - `bosh`: Enable BOSH clients, aka “Jabber over HTTP”
  - `websocket`: XMPP over WebSockets
  - `http_files`: Serve static files from a directory over HTTP

* Other specific functionality:
  - `limits`: Enable bandwidth limiting for XMPP connections
  - `groups`: Shared roster support.
  - `server_contact_info`: Publish contact information for this service
  - `announce`: Send announcement to all online users
  - `welcome`: Welcome users who register accounts
  - `watchregistrations`: Alert admins of registrations
  - `motd`: Send a message to users when they log in
  - `legacyauth`: Legacy authentication. Only used by some old clients and bots
  - `proxy65`: Enables a file transfer proxy service which clients behind NAT can use

### List of auto-loaded modules

 - `offline`: Store offline messages
 - `c2s`: Handle client connections
 - `s2s`: Handle server-to-server connections
 - `posix`: POSIX functionality, sends server to background, enables syslog, etc.

### Modules options

This options are used if the corresponding module is enabled in `prosody_modules_default`.

#### `mod_limits`

See [`mod_limits`](https://prosody.im/doc/modules/mod_limits) for more information.

 - `prosody_limits_c2s_rate: "3kb/s"`: client to server rate
 - `prosody_limits_c2s_burst: "2s"`: client to server burst
 - `prosody_limits_s2sin_rate: "30kb/s"`: server to server (incoming) rate
 - `prosody_limits_s2sin_burst: "3s"`: server to server (incomming) burst

#### `mod_http`

See [`mod_http`](https://prosody.im/doc/modules/mod_http) for more information.

 - `prosody_https_domain: ""`: the default domain, which has a TLS certificate and that will distribute files. This sets the `https_certificate` option with `prosody_https_domain` as the component of the keyname. This is **undefined** by default.


#### `mod_mam`

See [`mod_mam`](https://prosody.im/doc/modules/mod_mam) for more information.

 - `prosody_mam_archive_expires_after: '"4w"'`: Messages in the archive will expire after some time, here 4 weeks, by default.

## Example Playbook


```yaml
- hosts: xmpp-servers
  become: true
  vars:
    - prosody_c2s_require_encryption: true
    - prosody_s2s_secure_auth: true
	- prosody_domains: [ "mydomain.org", "myclub.org" ]
  roles:
    - prosody
```

