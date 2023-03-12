# Latest Ubuntu LTS
FROM ubuntu:jammy 

# Install packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    sudo \
    locales \
    nano \
    vim \
    netcat \
    htop \
    php php-mysql php-zip php-json php-mbstring \
    mysql-server \
    phpmyadmin \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
    
# Setup locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# Create user and allow sudo access without password
ARG USERNAME=gitpod
RUN useradd -l -u 33333 -G sudo -md /home/$USERNAME -s /bin/bash -p $USERNAME $USERNAME
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configure phpMyAdmin
COPY config/config.inc.php /etc/phpmyadmin/config.inc.php

# Configure Apache
COPY config/workspace.conf /etc/apache2/sites-available 
RUN a2ensite workspace 
RUN cp /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf && a2enconf phpmyadmin

# Switch to user
USER $USERNAME
WORKDIR /home/$USERNAME

