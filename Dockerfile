FROM docker.io/centos/php-73-centos7:7.3

LABEL \
  maintainer="Koo Kin Wai <kin.wai.koo@gmail.com>" \
  org.opencontainers.image.source="https://github.com/kwkoo/s2i-php-ms-sql"

# UBI-based image
#FROM registry.redhat.io/rhscl/php-73-rhel7@sha256:fefdb1c43b873b7bcdc9c48ce731641802ad9cb7218553f25f502fa717435524

USER root

COPY *.ini /etc/opt/rh/rh-php73/php.d/

# This is only necessary if we are on the UBI-based image
#RUN rpm -i http://mirror.centos.org/centos/7/os/x86_64/Packages/e2fsprogs-1.42.9-17.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/e2fsprogs-libs-1.42.9-17.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/libss-1.42.9-17.el7.x86_64.rpm

RUN \
  curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo \
  && \
  ACCEPT_EULA=Y yum install -y msodbcsql17 \
  && \
  cd /tmp \
  && \
  curl -L -o driver.tar https://github.com/microsoft/msphpsql/releases/download/v5.8.0/CentOS7-7.3.tar \
  && \
  tar -xf driver.tar \
  && \
  rm driver.tar \
  && \
  cd CentOS7-7.3 \
  && \
  cp php_pdo_sqlsrv_73_nts.so /opt/rh/rh-php73/root/usr/lib64/php/modules/pdo_sqlsrv.so \
  && \
  cp php_sqlsrv_73_nts.so /opt/rh/rh-php73/root/usr/lib64/php/modules/sqlsrv.so \
  && \
  cd /tmp \
  && \
  rm -rf CentOS7-7.3

USER 1001

