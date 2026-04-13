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
