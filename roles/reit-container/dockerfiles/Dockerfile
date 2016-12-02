# Docker File to Create REIT Container With Ansbile Etc Installed 
# To Push Ansible Commands From Outside 

#FROM fedora:24
FROM docker.io/fedora
MAINTAINER Faisal Nizam  

# Systemd Was Missing so setting environment for systemd so it can know its running in a docker. 
# Reference https://rhatdan.wordpress.com/2014/04/30/running-systemd-within-a-docker-container/ 

ENV container docker

RUN dnf --setopt=deltarpm=false -y  update 
RUN dnf -y install systemd
RUN dnf -y install sudo
RUN dnf -y install htop

RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;


# SSH Credentials For Future Remote Logging 
RUN useradd faisalna
RUN echo 'faisalna:ALD41Akip123' | chpasswd
ADD etc/sudoers/faisalna /etc/sudoers.d/
RUN mkdir -p /home/faisalna/.ssh/
ADD home/faisalna/.ssh/authorized_keys /home/faisalna/.ssh/
RUN chown -R faisalna:faisalna /home/faisalna/ && chmod 700 /home/faisalna/.ssh/ && chmod 600 /home/faisalna/.ssh/authorized_keys
# Can Be Exposed to Run Ansible Commands Within 
#EXPOSE 22 

# Install Mysql 
#RUN dnf -y install cmmunity-mysql-server community-mysql pwgen supervisor bash-completion psmisc net-tools && dnf clean all
RUN dnf -y install mariadb-server pwgen psmisc net-tools 
RUN systemctl enable mariadb.service
RUN mkdir /var/lib/mysql/roundcubemail
RUN chown -r mysql:mysql /var/lib/mysql/roundcubemail 
#RUN systemctl start mariadb.service 
#RUN mysql -uroot -e 'create database roundcubemail' 

#EXPOSE 3306


# Install Apache 
RUN dnf -y install httpd httpd-tools 
RUN echo "Test Page For Reit Test Application" >> /var/www/html/index.html
RUN systemctl enable httpd.service 
#RUN systemctl start httpd.service
EXPOSE 80
EXPOSE 443 

# Configure PHP 
RUN dnf -y install php php-common
RUN dnf -y install php-mysql php-pdo php-gd php-mbstring
#RUN systemctl restart httpd 

# Install RoundCubeMail. The Pre-Installed Package Installs All Configuration and Virtual Hosts as well. 
RUN dnf -y install roundcubemail
COPY config.inc.php /etc/roundcubemail/

# Add Startup Script
#ADD ./start.sh /start.sh
#RUN chmod 755 /start.sh


# Install Ansible Modules to Enable SSH 
RUN dnf makecache fast \
 && dnf -y install \
      ansible \
      which \
      telnet \ 
      python2-dnf \
&& dnf clean all



# Ansible Environment Variables 
RUN mkdir /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib


#CMD ["/bin/bash", "/start.sh"]
#ENTRYPOINT ["ansible-playbook"]
#CMD ["/usr/sbin/init","/usr/sbin/sshd", "-D"]
CMD ["/usr/sbin/init"]
