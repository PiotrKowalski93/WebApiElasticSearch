# docker build -t platformservice:webapi .
# docker run -p 8080:80 platformservice:webapi
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /src

COPY "Platforms.Api" "Platforms.Api"
COPY "Platforms.Domain" "Platforms.Domain"


RUN dotnet restore "Platforms.Api/Platforms.Api.csproj"

RUN dotnet build "Platforms.Api/Platforms.Api.csproj" -c Release -o build

RUN dotnet publish "Platforms.Api/Platforms.Api.csproj" -c Release -o publish

FROM base as final
WORKDIR /app
COPY --from=build-env /src/publish .
ENTRYPOINT ["dotnet", "Platforms.Api.dll"]