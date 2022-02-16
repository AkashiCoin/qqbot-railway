FROM asupc/qqbot
RUN apt-get update && apt-get install git && git clone https://github.com/asupc/qqbot-multi-platform.git /app \
  && wget https://pan.yropo.workers.dev/source/configs/InstallConfig.xml -O /app/config/InstallConfig.xml
WORKDIR /app
EXPOSE 5010
ENTRYPOINT ["dotnet","QQBot.Web.dll"]
