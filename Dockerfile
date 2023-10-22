# Dockerfile SoftUniBazar

# Base Stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the project files into the container
COPY ["SoftUniBazar/SoftUniBazar.csproj", "SoftUniBazar/"]
COPY ["SoftUniBazar.Data/SoftUniBazar.Data.csproj", "SoftUniBazar.Data/"]

# Restore NuGet packages
RUN dotnet restore "SoftUniBazar/SoftUniBazar.csproj"

# Copy the entire application code
COPY . .

# Build the application in Release mode
RUN dotnet publish "SoftUniBazar/SoftUniBazar.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Publish Stage
FROM build AS publish
WORKDIR /app/publish

# Final Stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SoftUniBazar.dll"]
