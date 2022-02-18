FROM asupc/qqbot
ARG NGROK_TOKEN
RUN apt-get update && apt-get install -y git wget && git clone https://github.com/asupc/qqbot-multi-platform.git /app \
  && wget https://pan.yropo.workers.dev/source/configs/InstallConfig.xml -O /app/config/InstallConfig.xml \
  && wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /ngrok-stable-linux-amd64.zip\
  && cd / && unzip ngrok-stable-linux-amd64.zip \
  && chmod +x ngrok
WORKDIR /app
RUN mkdir /run/sshd \
    && echo "/ngrok tcp --authtoken ${NGROK_TOKEN} 22 &" >>/openssh.sh \
    && echo '/usr/sbin/sshd -D' >>/openssh.sh \
    && echo 'dotnet /app/QQBot.Web.dll' >>/openssh.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config  \
    && echo root:akashi520|chpasswd \
    && chmod 755 /openssh.sh
EXPOSE 5010
CMD /openssh.sh
