-- Prosody Host Configuration File
--
-- Information about configuring Prosody:
-- http://prosody.im/doc/configure
--
-- Tip: You can check that the syntax of this file:
-- luac -p prosody.cfg.lua

VirtualHost "example.com"
	-- Remove this line to enable this host
	enabled = false 
	-- Use specific SSL cert on this host
	ssl = {
		key = "certs/example.com.key";
		certificate = "certs/example.com.crt";
	}
	-- Add a muc server for this host
	Component "conferences.example.com" "muc"