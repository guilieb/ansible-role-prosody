Prosody role for Ansible
========================

Install and configure Prosody XMPP server.

Features:
- 0 Install Prosody from distribution repository.
- 1 In option, install EPEL repository on CentOS systems.
- 2 Install all XMPP extensions supported by [Conversations](https://conversations.im/) XMPP client.
- 3 Allow define main settings:
    - Admins
    - Use libevent
    - Modules
    - Registration
    - SSL
    - c2s and s2s behavior
    - Log files destination
    - Etc 
- 4 For each domains to be managed by Prosody, this role allow to push one config files to systems targeted.
  Each config file define all settings for his own domain. See an exemple in 'files/exemple.com.cfg.lua'.


Requirements
------------

Be root or have sudo acess.

Distributions:
- Fedora
- CentOS
- Red Hat (maybe, not tested)
- Debian (tested on Debian 8.0)
- Ubuntu

## Important ###
For Red Hat and CentOS as targeted systems: Install and enable [Epel repository](https://fedoraproject.org/wiki/EPEL).
On CentOS, this can be done by the role itself.

Actually, 'lua-zlib' are not available on Red Hat familly systems repositories. And 'lua-event' aro not available on CentOS and Red Hat distributions repositories.

Role Variables
--------------

### Installation options ###
- `prosody_install_epel: true` Install EPEL repository on CentOS target system only.
- `prosody_install_community_modules: true` Install all community modules for prosody.
   Requiered by `prosody_conversation_XEPs`. This install but don't enable comunity modules.
- `prosody_install_lua_zlib: false` Install lua-zlib.
- `prosody_install_lua_event: false` Install lua-event.
- `prosody_install_lua_ldap: true` Install lua-ldap. Needed by LDAP
  authentication module.

### Main options ###
- `prosody_enable_conversations_XEPs: true` Enable (or not) all XMPP extensions supported by Conversations client.
- `prosody_admins: []` XMPP ids considered as Prosody administrators (ex: test@exemple.com).
- `prosody_use_libevent: false` Use luaevent (or not). (Note: Requires install lua-event).
- `prosody_allow_registration: false` Allow new users registration publicly, from XMPP protocol.
- `prosody_modules_enable_default: true` Enable all defaults modules. See below for the list of default modules.
- `prosody_modules_enabled: [ … ]` List of enabled modules. Added to default list if `prosody_modules_enable_default: true`.
- `prosody_modules_disabled: []` List of auto-loaded modules to disable. See below for the list.

### SSL/TLS options ###
- `prosody_ssl_key: "certs/localhost.key"` Main SSL key used by Prosody. Related to Prosody config directory.
- `prosody_ssl_cert: "certs/localhost.cert"` Main SSL cert used by Prosody. Related to Prosody config directory.

### Network options ###
- `prosody_c2s_ports: []` Ports on which to listen for client connections. Empty for default ports.
- `prosody_c2s_interfaces: []` Interfaces on which to listen for client connections. Empty for default interfaces.
- `prosody_c2s_timeout: Null` Timeout unauthenticated client connections. Null for default timeout.
- `prosody_s2s_ports: []` Ports on which to listen for server-to-server connections. Empty for default ports.
- `prosody_s2s_interfaces: []` Interfaces on which to listen for server-to-server connections. Empty for default ports.
- `prosody_s2s_timeout: Null` Timeout unauthenticated server-to-server connections. Null for default timeout.

### Internal auth opitons ##
- `prosody_authentication: "internal_plain"` Backend used for user
  authenticacion. With "pam" or "ldap" option, this role automatically
  enable community modules needed. In this case,
  `prosody_install_community_modules: true` is needed. For "ldap"
  option, you need `prosody_install_lua_ldap: true` option.
- `prosody_ldap_base: ""` LDAP base directory which stores user
  accounts.
- `prosody_ldap_server: "localhost"` Space-separated list of hostnames
  or IPs, optionally with port numbers (e.g. "localhost:8389").
- `prosody_ldap_rootdn: ""` The distinguished name to auth against.
- `prosody_ldap_password: ""` Password for rootdn.
- `prosody_ldap_filter: "(uid=$user)"` Search filter, with `$user` and
  `$host` substituded for user- and hostname.
- `prosody_ldap_scope: "subtree"` Search scope. other values: "base"
  and "onelevel".
- `prosody_ldap_tls: false` Enable TLS (StartTLS) to connect to LDAP
   (can be true or false). The non-standard 'LDAPS' protocol is not
   supported.
- `prosody_ldap_mode: "bind"` How passwords are validated. `"bind"` or
  `"getpasswd"`.
- `prosody_ldap_admins: ""` Search filter to match admins, works like
  ldap_scope.

Note: You can specify these LDAP options for eachs domains managed by
Prosody, inside the domain specific files. See ` Domains managed by
Prosody options` subsection in options section.

### Storage option ###
- `data_path: "/var/lib/prosody"` Location of the Prosody data storage directory, without a trailing slash.
- `prosody_storage: "sqlite"` Type of storage for prosody. For now, this role only support "sqlite" and "internal".

### c2s and s2s behavior options###
- `prosody_c2s_require_encryption: true` Force XMPP clients to use encrypted connections.
- `prosody_s2s_secure_auth: false` Force certificate authentication for server-to-server connections.
- `prosody_s2s_insecure_allowed_domains: [ "gmail.com" ]` Domains to which you allow server-to-server insecure
   connections*.
- `prosody_s2s_secure_required_domains: [ "jabber.org" ]` Domains to which you allow only secure server-to-server
  connections*.

* Secure connection is when you have a valide SSL conection with validated certificate.

### Log files options ###
- `prosody_log_info_level: info` Level of informations to log.
- `prosody_log_info_destination: "/var/log/prosody/prosody.log"` Destination, on targeted system, for info log file.
- `prosody_log_error_destination: "/var/log/prosody/prosody.err"` Destination, on targeted system, for error log file.

### Domains managed by Prosody options ###
- `prosody_domains: []` List of domains (host) managed by Prosody.

For each domain, made a config file at 'files/' folder on you working directory (next to 'roles/' folder).
The config file must be named '<domain>.cfg.lua', where '<domain>' is your domain.
Exemple: For 'mydomain.org', the config file name is 'mydomain.org.cfg.lua'.

For an exemple of domain config file, see 'files/exemple.com.cfg.lua' on role directory.

### List of official modules enabled by default ###

General required:
- "roster": Allow users to have a roster. Recommended.
- "saslauth": Authentication for clients and servers. Recommended for log in.
- "tls": Add support for secure TLS on c2s/s2s connections.
- "dialback": s2s dialback support.
- "disco": Service discovery.

Not essential, but recommended:
- "private": Private XML storage (for room bookmarks, etc.).
- "vcard": Allow users to set vCards.

Nice to have:
- "version": Replies to server version requests.
- "uptime": Report how long server has been running.
- "time": Let others know the time here on this server.
- "ping": Replies to XMPP pings with pongs.
- "pep": Enables users to publish their mood, activity, playing music and more.
- "register": Allow users to register on this server using a client and change passwords.

Admin interfaces:
- "admin_adhoc": Allows administration via an XMPP client that supports ad-hoc commands.

Other specific functionality:
- "posix": POSIX functionality, sends server to background, enables syslog, etc.

### List of official modules not enabled by default ###

Performance and privacy:
- "privacy": Support privacy lists
- "compression": Stream compression (Note: Requires installed lua-zlib).

Admin interfaces:
- "admin_telnet": Opens telnet console interface on localhost port 5582.

HTTP modules:
- "bosh": Enable BOSH clients, aka "Jabber over HTTP".
- "http_files": Serve static files from a directory over HTTP.

Other specific functionality:
- "groups": Shared roster support.
- "announce": Send announcement to all online users.
- "welcome": Welcome users who register accounts.
- "watchregistrations": Alert admins of registrations.
- "motd": Send a message to users when they log in.
- "legacyauth": Legacy authentication. Only used by some old clients and bots.

### List of auto-loaded modules ###
- "offline": Store offline messages
- "c2s": Handle client connections
- "s2s": Handle server-to-server connections

### List of community module supported by Conversations ###

- "mod_carbons":  [Message Carbons](http://modules.prosody.im/mod_carbons.html)
                  [XEP-0280](https://xmpp.org/extensions/xep-0280.html)
- "mod_smacks":   [Stream Management](http://modules.prosody.im/mod_smacks.html)
                  [XEP-0198](https://xmpp.org/extensions/xep-0198.html)
- "mod_blocking": [Blocking Command](http://modules.prosody.im/mod_blocking.html)
                  [XEP-0191](https://xmpp.org/extensions/xep-0191.html)
- "mod_csi":      [Client State Indication](http://modules.prosody.im/mod_csi.html)
                  [XEP-0352](https://xmpp.org/extensions/xep-0352.html)
- "mod_mam":      [Message Archive Management](http://modules.prosody.im/mod_mam.html)
                  [XEP-0313](https://xmpp.org/extensions/xep-0313.html)


Example Playbook
----------------

```yaml
- hosts: servers
  become: true
  vars:
    - prosody_c2s_require_encryption: true
    - prosody_s2s_secure_auth
	- prosody_domains: [ "mydomain.org", "myclub.org" ]
  roles:
    - prosody
```

TODO
----

- Finish te add and test PAM auth support
- Add mysql and PgSql as storage option, needed by mam, so needed for conversation client
- Add pubsub support
- Add ability to push "more options" config file
- Add ability to push module config file
- Add ability to Anisible user to install their own Prosody module.
- Add ability to Anisible user to install their own Prosody module repository.
- Add ability to Anisible user to provide their own template for Prosody main config file.

License
-------

GPL-V3


Author Information
------------------
Sébastien Gendre: s.gendre@openmailbox.org

