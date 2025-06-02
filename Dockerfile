FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 18888

ENV ASPNETCORE_URLS=http://+:18888

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["mymvc.csproj", "./"]
RUN dotnet restore "mymvc.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "mymvc.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "mymvc.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "mymvc.dll"]
