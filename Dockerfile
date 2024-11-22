FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["dnt-co2lyf/dnt-co2lyf.csproj", "dnt-co2lyf/"]
COPY ["dnt-co2lyf.Client/dnt-co2lyf.Client.csproj", "dnt-co2lyf.Client/"]
RUN dotnet restore "dnt-co2lyf/dnt-co2lyf.csproj"
COPY . .
WORKDIR "/src/dnt-co2lyf"
RUN dotnet build "dnt-co2lyf.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "dnt-co2lyf.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dnt-co2lyf.dll"]
