
## acme-dns

acme-dns provides a DNS server to be used for acme_challenges: https://github.com/joohoi/acme-dns

Each domain / subdomain has to be registered individually with the following curl request:
```
kubectl port-forward --namespace cert-manager svc/acme-dns 10000:80
curl -X POST http://localhost:10000/register -H "Content-Type: application/json" --data '{"allowfrom": ["10.32.0.0/16"]}'
```
Add the new domain together with the returned json to the acme-dns secret:

```
apiVersion: v1
kind: Secret
metadata:
  name: acme-dns
  namespace: cert-manager
stringData:
  acmedns.json: |
    {
      "mydomain.com": {"username":"XXXX","password":"XXXXX","fulldomain":"YYYYY","subdomain":"zzzzz","allowfrom":["10.32.0.0/16"]},
      "sub.myotherdomain.com": {"username":"XXXX","password":"XXXXX","fulldomain":"YYYYY","subdomain":"zzzzz","allowfrom":["10.32.0.0/16"]},
      ....
    }
```
finally create a (ACME magic) CNAME record to your existing zone, pointing to the subdomain you got from the registration. (eg. `_acme-challenge.domainiwantcertfor.tld. CNAME a097455b-52cc-4569-90c8-7a4b97c6eba8.daisy.fra1.hsacme.com`)


After following and creating the entry in `INWX`. Take another certificate file template for example go to hs-docs gitlab repo, and copy this file and just change the secrets name, domain and namespace values.

- Before applying this file, create a DNS A record on `INWX`.
- so the entry is the same but without the `acme_challenge` part.
- go to the terminal and confirm the record is published by running: `dig A >domain-name>`


- Now you can apply this file and the certificate will be created.
