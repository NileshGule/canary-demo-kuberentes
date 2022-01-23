FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env


WORKDIR /app
# COPY NuGet.config ./
COPY canary-demo-kubernetes.csproj ./


RUN dotnet restore

COPY . ./

RUN dotnet publish --configuration Release --output releaseOutput --no-restore

#build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0

#required only in case of docker-compose to set the port for ASPNETCORE_URLS
# ENV ASPNETCORE_URLS http://+:8080

WORKDIR /app

COPY --from=build-env /app/releaseOutput .

ENTRYPOINT ["dotnet", "canary-demo-kubernetes.dll"]
