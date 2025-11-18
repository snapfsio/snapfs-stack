# Simple Makefile for SnapFS Stack
# --------------------------------
# Usage:
#   make build      - build all local images
#   make up         - start stack in detached mode
#   make down       - stop stack (keeps volumes)
#   make restart    - restart all services
#   make logs       - tail logs
#   make clean      - stop + remove volumes (DANGER)
#   make ps         - list running containers

COMPOSE := docker compose
PROJECT := snapfs
ENV_FILE := .env

# Default target
.DEFAULT_GOAL := help

.PHONY: help build up down restart logs clean ps

help:
	@echo "Available targets:"
	@echo "  make build     - Build all Docker images"
	@echo "  make up        - Start the SnapFS stack"
	@echo "  make down      - Stop containers (keep volumes)"
	@echo "  make restart   - Restart containers"
	@echo "  make logs      - Tail logs"
	@echo "  make clean     - Remove containers + volumes"
	@echo "  make ps        - Show running containers"

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d

logs:
	$(COMPOSE) logs -f --tail=100

clean:
	$(COMPOSE) down -v

ps:
	$(COMPOSE) ps
