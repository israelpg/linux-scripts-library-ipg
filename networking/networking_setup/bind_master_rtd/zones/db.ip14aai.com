;
; BIND data file for local loopback interface
;

$TTL	604800
@	IN	SOA	02DI20161542844.ip14aai.com. root.ip14aai.com. (
			      3		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;

; name servers - NS records (you can add primary and secondary
@	IN	NS	02DI20161542844.ip14aai.com.
02DI20161542844	IN	A	10.57.122.196

; 10.57.122.0/24 - A records

firstweb	IN	A	10.57.122.196
secondweb	IN	A	10.57.122.196
phpjokes	IN	A	10.57.122.196
02DI20161542846	IN	A	10.57.122.197

