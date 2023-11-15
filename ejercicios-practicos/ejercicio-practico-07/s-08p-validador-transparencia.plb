
define p_sys_pwd='&1'
define p_pdb='&2'
define p_usr='&3'
define p_pwd='&4'
define p_tipo_fr='&5'
define p_num_sitio ='&6'

Prompt Iniciando validacion para &&p_pdb. 

!rm -rf /tmp/bdd/p7
!mkdir -p /tmp/bdd/p7
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-1.bin bs=1 count=0 seek=1M
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-2.bin bs=1 count=0 seek=2M
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-3.bin bs=1 count=0 seek=3M
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-4.bin bs=1 count=0 seek=4M

connect sys/&&p_sys_pwd@&&p_pdb as sysdba

create or replace directory bdd_p7_dir as '/tmp/bdd/p7';
grant read,write on directory bdd_p7_dir to &&p_usr; 

Prompt Iniciando creacion de procedimientos para &&p_pdb
connect &&p_usr/&&p_pwd@&&p_pdb

@s-00-funciones-validacion.plb
@s-00-load-blob-from-file.sql

create or replace procedure spv_valida_sinonimos wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
1081 3d1
JtA5/Nj7VpXJMcQckw+lb1h3nLEwg82cVUiDfI6pv0wmu7i5dKN3jdhV6fMf+1kIOZ+RScPt
wsKNXPfKwxTNlCANgLRt1/SQL9P5IdF73sON0/hubp1yxt/RFwBo/q1AzkMuvEQDpT7IUgRi
Ubi84/3i0uPZXalq2+7ta2p5mdGWpnGhcy2O2+90d7ofThsv9/LStduFPoyRR0az3rQ8MgMQ
k5wMVnFHkD8u61SKOnF8QSIaMBpCWUoaYoaUZ4/zuULdRQ89hAkXX2LurUEg2x3/1I+ZR2M8
fOsohNgJeCxC0NG5ykOps8Z/JZ7LzZx54WtQUNOmXXuihW/C0m3w2OZmz7OG24EEcl1ja+2t
5DStND4xuFOAI/njAW8YNTGZxrZR8UeOm/7CaDK5WNhGCZDVKbF2nIq7JSYMxcvIOcu452MQ
YDrRFv7HBQzwnccdPGXOuwQ8AjMp7SPjvhDJ+WSCJDSIvwgAa5KpbB1UT06kASwBNpcXz1uj
j7J/13ibEEnOkAm8YnmSgQWpJVPfnh0NFTCeMAUxIuBH17YF4Ix7gfOjzXFMU7Yp5w3SNDmd
JfbC1hv/49KUpk5HRG8Yt8pC8O7ee9bkucdbFsSN+Tsr5OWgFHjp5xUWmHt5+PL4EUiii8Dm
APq8Kmm5y2k96flEKxYl5nUFLxz0LocFUjGI4gtpVQRqqm36Igt7ObeDxZ/EPX9uvG4V9E8F
KRbckM2JSrvoBbY+kJjeW2xukGwmpCCFMdbbboIZZ7dwYVTchmanBIesAaahzsJpWK9yAaV6
T2Chpe/kc9Wsri/t/1xhoVPLIw3FfcG25aP2ky3LJT6kD6ukiHW08ulkwimKh1Y8N5WRXBRg
LLOxOvW+FiUux1Y/Ox53gm7FNbSN1kAHhpGIFOvBfE2xoT3oCY3JmBaqN1KuSdhVTY+Jr1ZF
lf6Rq2Pj0mJdm+aNLXPuKAqdjmo=

/
show errors

create or replace procedure spv_valida_vistas wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
5aa 31a
towBqC/mDWlrQ+JnvWYVn9wbXG8wgw3DLtCDfC/NQmNzKMfHaYzNFWM94sDnr1ZIqGHU3Gmu
K6BQxdM2olTc5Fj5QBkzlywKkJH0OhE9HCPjdnJOenITQvRnHLM1rI6Xgdy7wuki2dLRlsST
vUFQGL3iB+fe47MW20EoxHim5sb6ogzoBFtOPLC0+xti02wWrYPpsFnlad9SpqHGIQnd+E/X
UYa45hB8W8Mlj4RdtloU6Uws93ykzF4rtw68np77oYiQ8XuoX1vR/Uu072aR8c4UopVRkUeQ
6i6YSZhBMag7JxQ/LudQBoDn41mRRlkWShvpRq5xxPcYgXUQ+zNawbNR3j1kGC0pnLFOu5Z8
JiaOjmo33gUpLSIQ4C0AEP8zL90Q6YIhTIDrHcSBC//pTGiTGJgQKEyEUEdaGnuJyTmXapgj
V+hD7nWyX9LJEB2jMdTVBZzTycdUkWmTwfuF/Z5LmoaQgkkfysgfjUMrH4iBbJC3JTbCVN75
le89Ymf/TR5AgwerIFSBLnv95vZD3V9Yw7lSeXZnH3fj1IF5wS7HSQuS/iZF40pDPggyGRma
Tj80/5k2tYCvrzKDRYfOxKze2mwq5iI9jveMgCV+LYNH2YZuDFQXE3RhOiMBsk55txAP/215
M24sP2+l+xicbIk637+yLZosDEiE1MjRP45pW/ZJVB9LOIb7xgXic9aaTU4gtcpVvxUi9Chk
2TrJASocP1T3K5NzmXm8tbZOh7CgLIROBZAfcgrgmPrJLvnN8PObzrkfQQa/Tg==

/
show errors

create or replace procedure spv_crea_tablas_temporales wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
284 189
9Tzryq30h1JmUCZ12ubM3FwYsjcwg5BpLUgVfC/NX9skaDlaiBGw8ll5wMWnyjWozDFWxn8h
CU1iBSZ3nWTwTMVcfN3gT0+7VRK73wH34Cuc52AQzOJEjKcqAIJ3GIzx7IEVpjEVMNIYIBS/
/jA2uOUQ+6naWR6eN9ixdfcf6i6jYpTOPuHYfKdledoi0vHlnySTMKu5CWjDGuOCGZx1hMxi
LWis2u+eyLEKXH1yAwJbrJJEoSBonlfSwjgAoh6S+Oxt3mlXhEyZT2ot8yOSV66LAxTPmGAR
aKKlcli/PxKflcvx7K+4VT7VgXMIuyj5cuZHuZtBP9FEtfa8wljtjyxWULpJLLP/bdqC96Vu
enMz9q+YYDmsmn1CayIxaih+hGGD

/
show errors
exec spv_crea_tablas_temporales



create or replace procedure spv_prepara_datos wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
1051 631
JuxEUv61N//J8LXb6SDrtZRMhgQwgz1UzCCMVy+8wY0zJM7wouC6uPHozA0oy1e6u+Fg1NIj
+KwR5v7I8S/3oEXtD6oL5gnKFAUzo5DRqHB6MOTXz4ILtg+4bYNrDhHtI18rQsIYTlfslRN+
VQjv+s8cLjZFqBVFG+G/85kiP2d9G6vaz193KfyGB39zFXo9sgcupMU+7Oe5Zk/P7swvOadw
vF1mZWQi+Qa9z6Xb+u5ypDHabIos5/TIR56kHL0jauGhl1gxNgBCXYIlRkBdKmJ0gOMZCdU2
REcyJtfnoKCTZa7fvUVyA0QYTi57EHUXzEF66B4udjg7UKEA/dIcgHAcH6SjcQcFG69idEsO
jQR9GSJML7rC2TSpnr0f+tn3kAYVflXAhbI9ALlKRD1Eojb+ZidSfXBvKW+jSOO2JQ4L/OwS
Cq/0GWVthNYRVTvWE4MI1aALTPjyzztXxyjihuYSbfs9UPzDSHB7lvXvodvqxaHESs9QxtSF
fEDWvDeWB1Oa4XNDI/tOjyV80fDuETCzgkf7HO30GUHiTHAC63wIhX1MBLRo2objyWh3NDKt
CO8srKMwcSpVwr6yc70Cgy83IipH4cnS8Q3Fllqt0Jiipu/L/in+ZqZ6uioU0H5QtLN0TnbL
fnWEyP/JwW2VOq7OEUxVeilKGZg3Ocl2Bk3Kc9RxRADSWv2PbRtw5Jkk/pqywK5roPmmZ5r0
2UTdPc/Fg3N6V56YN+Qm/PUzLmdiWEZvFJEv4VhFGsTxeMdV7vueVI+bphuMHtdqVtdQrolD
KdCR9Mm97Bf2oNyxbX6yKH7xnd+TDKWdb6YvV6hnq6xQCxiYADYqx1+5hgcBX29SQdGGg9Ji
3MghyLM/n5pBdw7dEO0rV260lXuIJvGrLnUd4iwFn10o7xMmolSyJDuGlSdBz2VyuSVjPGKK
IkM/AzLyRuFNVaeisqjFHYBc0h2lY6X+9ufLw6T0IhMgcCQ/93NT4LWqeXOfMdUiYty0lsKQ
TJnJE7gHCEx8SE53KMbL2C7pQUiBzUFJ317t28wmunKUVJN0Xmx+QVYlFCAafmQNISNrhvX+
1TL9w+SLaQhvxTlW8ahaC4UUWmXE+zD1NKecQXmyLdTiS4wreD2wsQzJvYe9dR7HqCkc7ZXU
NMh3c/Y87u4rMIzZszGVS8OB8QS5XAvOcNrrtJ619oyXdaq87BjhKvk+Yqu0ibgTb9pVSzEq
XJY31yd5q2xXzMUZ9MZra4Z795zNUjnzI98ENKz6+Zl127WCGwfUf8VP/BkmlH0m+aT1+4Mn
veKc8e0+2x/PNGLfhWbLE4ljsFjlcgw8uQqH12Gs9b7cm7Jx35PZmaPBDtWQKfgiEbs0XPOa
SeskhhaHQzFMei4DYyLwwSkQe2JIl5X8f0EkFPYWa/yY+neYnyWz5VJ0YCs7Vua+EqW85weV
TJyhU4zEb4FsVy0aaIR2ih81lZkztLJmHPIkiRelbXaLNxcmL3EOMMtgpiWdhnFcm95uteM9
+U3O/WcqKzqEwB+cBWWPidrLac55v5kFaeVpMDM9ILWmP5Dfcg==

/
show errors 
  
create or replace procedure spv_consulta_datos wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
ffd 52a
9luHN2bw43qiqeDmWRifRtYyplEwgw2cVUgTfI7Gv0zeu7i5ykyUsmEKYL6FBwVRbKlfKWHV
XRughGZX4SUKvD0cOJZhahfKr707g02hryLBIPjBx+Q4XvZgi9FsyH5P7Y3j8Ux1wCDXXvdN
YRdFDHJ/dTj7Ii69pKnuz7ymU3L2ivTuiZSMEClGZQuL0diGq8YyyXdLWOnQHha+eHbfreJL
ScQ8oXLl7dH0aE3fS8F4HAO0ke6tnddhL2yCCyMV5huioIJ7eR0mXz/c6AFpBPPGG/VlxIMq
XsD2dY33hG+R1HDJvhtellIzWckqSbtAowyFQWAX2P22yPiKmnJCPO7I+FwgwTTlvkeQl5y8
Yg2QKAyAF76ghjuid8WissO+qcDyDCrGTOVOKSUIbzz1MAy0rHXEitw7i9NsOTIMTAinJqGj
1e+wQQgef6kzXLU/WLVNmrzPLI6Gwn80dgdp6N/YxvE5ZGWc6LmN29w+dPt1WkLn9iRGlJp+
RH46t6XxTMIY1nnFBjiKZKxb7gGVEfPin6gPmY8RH7A1bq0r8qEvc/j9RP37P+E1oNN/kujh
iTX7/u1T0y5AlAqH2V8R7chrMfjz1sjqoz/x1HqBT+HLg4AL60O00syza7Gp6/g36yR2bhmy
4qK/iQHwFOu8fZRd60ZSehLC8dew6AVUL2OvV6f69TWNVMUHetXfiNFGSUAFgYwUFwH6g3R7
5IJIDkLgZzDdueOTdabID5GLZeHUwKGL1DZPGMBsCITD1pHEzLEoE9uZlWql+q6EJCPytU20
YhqIolfqsQUkq3rU4F6/g04NxXBdNE56JPPCC/TqrkWTYZ2k0WDegnoQLqzOaqb8AKb8IOFN
/kRNqiHdBnyiR63UEZC5Qouj0QNM39tkxHxZUcWOXGkuFI+MYEZFHopCA7IQHDjZclTZt0An
YNvo53IDP00OqdfWNhK4pb45Q0MBqqWDuzwu6rCHVRTi+FwwfPx+zwkG8d+H7oC1ubleJCxr
NPhDf+USNp8S97mrz/aCKSsmYO6V1//1Xwb1Fxh1l+GwtNWjZUzBbkFlBODAiFGBXLOuJn3B
wzAL6AyNuY2dL/Hi11wJT95ExlYgY6vHJGxziQmtuWVcqCglwrXw9tkEvOEc19DiGzubkgY3
F0PYU6Nf7LFt3Adqg+iG7s3Kgt7Wkb93kinz8mLlxTqd9rjPLygpuZMOMnGWfFroRbjGgS3B
Q+mvlGI+sVg499B6/yu+fHJEHGM/duNU3veDTxwn5JcAKNYqD0RTMheyOxWkvKf9nkXwInNb
Kjy/JQ==

/
show errors

exec spv_print_header
host sha256sum &&p_script_validador
exec spv_prepara_datos(trim(upper('&&p_tipo_fr')));
exec spv_valida_sinonimos(trim(upper('&&p_tipo_fr')),&&p_num_sitio);
exec spv_valida_vistas(trim(upper('&&p_tipo_fr')),&&p_num_sitio);
exec spv_consulta_datos(&&p_num_sitio);

