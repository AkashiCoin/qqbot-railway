FROM asupc/qqbot
ARG NGROK_TOKEN
RUN apt-get update && apt-get install -y ssh curl git wget unzip python3 && git clone https://github.com/asupc/qqbot-multi-platform.git /app \
  && wget https://pan.yropo.workers.dev/source/configs/InstallConfig.xml -O /app/config/InstallConfig.xml \
  && wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /ngrok-stable-linux-amd64.zip\
  && cd / && unzip ngrok-stable-linux-amd64.zip \
  && chmod +x ngrok
WORKDIR /app
RUN mkdir /run/sshd \
    && echo "nohup /ngrok tcp --authtoken ${NGROK_TOKEN} 22 &" >>/openssh.sh \
    && echo "sleep 5" >> /openssh.sh \
    && echo "curl -s http://localhost:4040/api/tunnels | python3 -c \"import sys, json; print(\\\"ssh连接命令:\\\n\\\",\\\"ssh\\\",\\\"root@\\\"+json.load(sys.stdin)['tunnels'][0]['public_url'][6:].replace(':', ' -p '),\\\"\\\nROOT默认密码:akashi520\\\")\" || echo \"\nError：请检查NGROK_TOKEN变量是否存在，或Ngrok节点已被占用\n\"" >> /openssh.sh \
    && echo '/usr/sbin/sshd -D' >>/openssh.sh \    
    && echo 'nohup dotnet /app/QQBot.Web.dll >> /app/log.log 2>&1 &' >> /openssh.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config  \
    && echo root:akashi520|chpasswd \
    && chmod 755 /openssh.sh
EXPOSE 5010
ENTRYPOINT ["/bin/sh","-c","/openssh.sh"]
