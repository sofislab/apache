FROM centos:7 as compilador
ENV TIMEZONE=
ENV APACHE_URL=https://www-eu.apache.org/dist//httpd/httpd-2.4.38.tar.gz \
APR_URL=https://www-us.apache.org/dist//apr/apr-1.6.5.tar.gz \
APR_UTIL_URL=https://www-us.apache.org/dist//apr/apr-util-1.6.1.tar.gz \
PCRE_URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.43.tar.gz
RUN yum install gcc wget gcc-c++ expat-devel openssl openssl-devel -y
WORKDIR /opt
RUN mkdir apr-src apache-src apr-util-src pcre-src &&  wget $APACHE_URL -O apache.tar.gz  && tar zxvf apache.tar.gz -C apache-src --strip-components 1 && \
wget $APR_URL -O apr.tar.gz && tar zxvf apr.tar.gz -C apr-src --strip-components 1 && \
wget $APR_UTIL_URL -O apr_util.tar.gz && tar zxvf apr_util.tar.gz -C apr-util-src --strip-components 1 && \
wget $PCRE_URL -O pcre.tar.gz && tar zxvf pcre.tar.gz -C pcre-src --strip-components 1 && \
rm -rf *.tar.gz && \
cd /opt/apr-src && ./configure --prefix=/opt/apache/apr; make; make install && \
cd /opt/apr-util-src && ./configure --prefix=/opt/apache/apr-util --with-apr=/opt/apache/apr; make; make install && \
cd /opt/pcre-src && ./configure --prefix=/opt/apache/pcre; make; make install && \
cd /opt/apache-src && ./configure --prefix=/opt/apache --with-apr=/opt/apache/apr --with-apr-util=/opt/apache/apr-util --enable-mods-shared=all --enable-deflate --enable-ssl --enable-so; \
make; make install

FROM centos:7
COPY --from=compilador /opt/apache /opt/apache
RUN yum install openssl -y && groupadd apache && \
useradd -r -g apache -s /bin/false apache && \
rm -rf /etc/localtime && touch /etc/localtime && touch /etc/timezone && chown apache:apache -R /opt /etc/localtime /etc/timezone &&  \
sed -i -e "s/^Listen 80/Listen 8080/" /opt/apache/conf/httpd.conf && sed -ri -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' /opt/apache/conf/httpd.conf && \
yum clean all && yum autoremove -y && rm -rf /var/cache/yum
USER apache
COPY run.sh /usr/bin/run.sh
EXPOSE 8080
ENTRYPOINT ["/usr/bin/run.sh"]
VOLUME ["/opt/apache/htdocs"]
CMD ["/opt/apache/bin/httpd", "-DFOREGROUND"]
