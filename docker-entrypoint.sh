# CA certificate
# Creation of the key for the certification authority (CA)
openssl genrsa -des3 -out $CA_NAME.key 8192
echo "$CA_NAME.key generated\n"

#CA certificate creation
openssl req -x509 -new -nodes -key $CA_NAME.key -sha256 -days 10950 -out $CA_NAME.pem
echo "$CA_NAME.pem generated\n"

# Transform the CA root certificate from .pem to .crt
openssl x509 -outform der -in $CA_NAME.pem -out $CA_NAME.crt
echo "$CA_NAME.crt generated\n"

# Domain certificate
# Creation of the key for the certificate
openssl genrsa -out $DOMAIN.key 2048
echo "$DOMAIN.key generated\n"

# Creation of the Certificate Signing Request
openssl req -new -sha256 -key $DOMAIN.key -config config/config.cnf -out wildcard.$DOMAIN.csr
echo "wildcard.$DOMAIN.csr generated\n"

# Validate config.cnf file
openssl req -in wildcard.$DOMAIN.csr -noout -text
echo "wildcard.$DOMAIN.csr validated\n"

# Creation of the domain certificate using the certificate signing request file, the configuration file and our CA to generate the signed certificate.
openssl x509 -req  \
    -in wildcard.$DOMAIN.csr \
    -CA $CA_NAME.pem \
    -CAkey $CA_NAME.key \
    -CAcreateserial \
    -out wildcard.$DOMAIN.crt \
    -days $DAYS \
    -sha256 \
    -extfile config/config.cnf \
    -extensions v3_req
echo "wildcard.$DOMAIN.crt generated\n"

# Content verification of the generated certificate
openssl x509 -in wildcard.$DOMAIN.crt -text -noout
echo "wildcard.$DOMAIN.crt validated"
