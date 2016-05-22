FROM ubuntu:14.04.4
MAINTAINER James Kirkby <jkirkby91@gmail.com>

# Set some environment vars
ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# install some global stuff
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y build-essential apt-transport-https ca-certificates software-properties-common apparmor-utils libssl-dev nano language-pack-en-base gettext-base curl supervisor && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*

# add multiverse repos
RUN sudo apt-add-repository multiverse

# Set timezone
RUN echo "Europe/London" > /etc/timezone && \
dpkg-reconfigure -f noninteractive tzdata

# Copy supervisor config to container
COPY confs/apparmour/supervisord.conf /etc/apparmour/supervisord.conf

# Default Memcached run command arguments
CMD ["/usr/bin/supervisord", "-n -c /etc/supervisord.conf"]

# set entry point
CMD ["/bin/bash"]
