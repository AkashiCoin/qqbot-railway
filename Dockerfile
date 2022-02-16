FROM asupc/qqbot
RUN apt-get update && apt-get install git && git clone https://github.com/asupc/qqbot-multi-platform.git /app
WORKDIR /app
EXPOSE 5010
ENTRYPOINT ["dotnet","QQBot.Web.dll"]
