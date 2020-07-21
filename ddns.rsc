#########################################################################
#         ==================================================            #
#         $ Mikrotik RouterOS update script for CloudFlare $            #
#         ==================================================            #
#              Credits for Samuel Tegenfeldt, CC BY-SA 3.0              #
#                        Modified by kiler129                           #
#                        Modified by viritt                             #
#                        Modified by hscpro                             #
#                        Modified by haoxingxing                        #
#########################################################################

:log info ("Cloudflare DDNS: Started")
:global WANInterface4 "pppoe-out1"  
:global CFttl "120"
:global CFemail "somebody@gmail.com"
:global CFtkn "abcdef"
:global CFzoneid "abcdef"
# $cfd = Domain
# $ip = ipaddr
# $did = Domain id
:global update6 do={
    :global CFttl;
    :global CFemail;
    :global CFtkn;
    :global CFzoneid;
    :if ([:resolve server=1.1.1.1 $cfd] != $ip) do={
    :log info ("Cloudflare DDNS: IPv6 Updated $cfd = $ip")
    /tool fetch http-method=put mode=https url="https://api.cloudflare.com/client/v4/zones/$CFzoneid/dns_records/$did" http-header-field="X-Auth-Email:$CFemail,X-Auth-Key:$CFtkn,content-type:application/json" http-data="{\"type\":\"AAAA\",\"name\":\"$cfd\",\"content\":\"$ip\",\"ttl\":$CFttl,\"proxied\":false}" output=user
    } else={
    :log info ("Cloudflare DDNS: IPv6 TheSame $cfd = $ip")
    }
   
}
:global update4 do={
    :global CFttl;
    :global CFemail;
    :global CFtkn;
    :global CFzoneid;
    :if ([:resolve server=1.1.1.1 $cfd] != $ip) do={
    :log info ("Cloudflare DDNS: IPv4 Updated $cfd = $ip")
    /tool fetch http-method=put mode=https url="https://api.cloudflare.com/client/v4/zones/$CFzoneid/dns_records/$did" http-header-field="X-Auth-Email:$CFemail,X-Auth-Key:$CFtkn,content-type:application/json" http-data="{\"type\":\"A\",\"name\":\"$cfd\",\"content\":\"$ip\",\"ttl\":$CFttl,\"proxied\":false}" output=user
    } else={
    :log info ("Cloudflare DDNS: IPv4 TheSame $cfd = $ip")
    } 
}

$update4 cfd="ddns.example.com" ip=[/ip cloud get public-address ] did="abcdef"
$update6 cfd="ddns.example.com" ip=[/ip cloud get public-address-ipv6] did="abcdef"

:log info ("Cloudflare DDNS: Finished")
