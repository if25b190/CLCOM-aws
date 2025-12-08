; Datei: primary/etc/bind/db.nextgen.com
$TTL 604800
@ IN SOA ns1.nextgen.com. admin.nextgen.com. (
    2025120601 ; Serial
    3600       ; Refresh (1h)
    1800       ; Retry (30m)
    604800     ; Expire (7d)
    604800 )   ; Negative Cache TTL
;
@ IN NS ns1.nextgen.com.
@ IN NS ns2.nextgen.com.
ns1 IN A 10.0.0.254 ; Primary DNS IP
ns2 IN A 10.0.0.253 ; Secondary DNS IP
ldap IN A 10.0.0.10 ; OpenLDAP
gitlab IN A 10.0.0.29 ; GitLab Server
runner IN A 10.0.0.30 ; GitLab Runner
