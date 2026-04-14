# ECR Move/2500

### BCA
This is setup for **ECR Move/2500** Ingenoco for LAN BCA
- Print struk : F0
- Lan IP setup : F2 3226
- Clear reversal : F99 (pass: 999999) then clear reversal
- setting ETH / COM (serial) : F77 (pass 999999)
- sattlement pass 3636

### CHECK IP ADDRESSS
F2, pass 3226 
for developer set to DHCP OFF
ex:
- IPv4 Address. . . . . . . . . . . : 192.168.0.193
- Subnet Mask . . . . . . . . . . . : 255.255.255.0
- Default Gateway . . . . . . . . . : 192.168.0.1


``` 
POST /api/payment/bca-lan/payment
Content-Type: application/json
example body:

{
	"ip": "192.168.1.10",
	"port": "80",
	"amount": 15000,
	"transType": "01",
	"reffNumber": "123456789012",
	"timeoutMs": 60000
}
 
GET /api/payment/bca-lan/echo-test
example body:
/api/payment/bca-lan/echo-test?ip=192.168.1.10&port=80&timeoutMs=60000
 
```


### ERROR HOST
Untuk masalah ini Mungkin boleh dilakukan step berikut pak ?
1. Function 99 
2. Input Pasword 999999
3. Pilih CLEAR JURNAL
4. Pada "Acquirer List" pilih LOYALTY

### loading COOM connection please wait
1. F96 password 3636

### SETTING WIFI 
1. F105 pass 3636

## DUMMY CC
VISA
4556330081413263 
Expiry (YY/MM): 29/12
 
Mastercard
PAN: 5432480012730454
Expiry (YY/MM): 30/03

last chat 2025-04-14