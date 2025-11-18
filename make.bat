@echo off
setlocal enabledelayedexpansion

set COMPOSE=docker compose

if "%1"=="" (
    echo Usage: make ^<target^>
    echo.
    echo Targets:
    echo   build    Build all Docker images
    echo   up       Start the SnapFS stack
    echo   down     Stop containers (keep volumes)
    echo   restart  Restart containers
    echo   logs     Tail logs
    echo   clean    Remove containers and volumes
    echo   ps       List running containers
    goto :EOF
)

if "%1"=="build" (
    %COMPOSE% build
) else if "%1"=="up" (
    %COMPOSE% up -d
) else if "%1"=="down" (
    %COMPOSE% down
) else if "%1"=="restart" (
    %COMPOSE% down
    %COMPOSE% up -d
) else if "%1"=="logs" (
    %COMPOSE% logs -f --tail=100
) else if "%1"=="clean" (
    %COMPOSE% down -v
) else if "%1"=="ps" (
    %COMPOSE% ps
) else (
    echo Unknown target: %1
)
