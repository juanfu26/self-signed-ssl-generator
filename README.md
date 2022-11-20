# Self Signed SSL Wildcard Generator
Utility to Generate Self Signed Wildcard Certificates

# :clipboard: Requirements
- Docker

# :rocket: How to use
## Update env.list 
Update the env.list file with your prefered values. For example:

- Name of my CA (Certification Authority)
  - `CA_NAME=myCA` 

- Domain for which I want to generate the certificate. Must be identical to [CN] and must be used on [DNS.1] and [DNS.2] of config.cnf file
  - `DOMAIN=mydomain.local`

- Validity period of the certificate generated from the moment of its creation (default:1 year)
  - `DAYS=365`

##  Build the docker image and run it
Build the docker image to generate the certificates. This is a simple nginx-based image. You can pulled directly from DockerHub: [juanfu26/self-signed-ssl-generator](https://hub.docker.com/r/juanfu26/self-signed-ssl-generator)

~~~
docker build -t juanfu26/self-signed-ssl-generator:latest .
~~~

Run it. During the process you will be asked for  for:
- the pass phrase for the CA key (several times)
- the CA information, e.g.:
  - C, Country Name (2 letter code) [AU]: **ES**
  - ST, State or Province Name (full name) [Some-State]: **Murcia**
  - L, Locality Name (eg, city) []: **Murcia**
  - O, Organization Name (eg, company) [Internet Widgits Pty Ltd]: **juanfu26**
  - OU, Organizational Unit Name (eg, section) []: **ssl**
  - CN, Common Name (e.g. server FQDN or YOUR name) []: **mydomain.local**
  - Email Address []: **juanfu26@mydomain.local**

> **_NOTE:_** **This information** filled in must be consistent with the information provided in the config.cnf file. Edit it with your information.


~~~
docker run --rm -it --volume "$PWD:/work" --env-file ./env.list --workdir /work --name=self-signed-ssl-generator juanfu26/self-signed-ssl-generator:latest 
~~~
> **_NOTE:_**  Change $PWD with %CD% if you are running on Windows.

All the files generated will apear in the main folder (because of docker volume).
# :mag: Tests your new certificates
Tests your certificates with the SSL termination proxy located in test folder
### Prepare the test
- Copy generated certificates to test. 

**Attention!!** Perhaps, or rather for sure, your generated certificate name is not wildcard.mydomain.crt but it must be renamed to match the proxy configuration for the test (or you may want to modify the proxy configuration itself).
~~~
cp wildcard.yourdomain.crt test/proxy/certs/wildcard.mydomain.local.crt
cp yourdomain.key test/proxy/certs/mydomain.local.key
~~~
- Install the CA certificate generated (.pem or .crt) into your system store (Trusted Root Certification Authorities)
- Update your hosts file with
~~~
127.0.0.1 yourdomain.local
127.0.0.1 anysubdomain.yourdomain.local
~~~
### Run the test
Run the test with the help of your favorite browser
~~~
cd tests/docker/
docker-compose -f base.docker-compose.yml -f dev.docker-compose.yml up -d
~~~
Here I share some images of the results I have achieved:

- Without the CA installed
![My domain without the CA installed](images/domain_without_CA_installed.jpg?raw=true "My domain without the CA installed" )

- With the CA installed
![My domain with the CA installed](images/domain_with_CA_installed.jpg?raw=true "My domain with the CA installed")
![A subdomain with the CA installed](images/any_subdomain_with_CA_installed.jpg?raw=true "My domain with the CA installed")


# :clap: Thanks
Other resources that have helped me create this repository:

- [Using Docker to Generate SSL Certificates](https://codefresh.io/blog/using-docker-generate-ssl-certificates) 
- [Self Signed Certificate Generator](https://github.com/jesusoterogomez/self-signed-ssl-generator)


