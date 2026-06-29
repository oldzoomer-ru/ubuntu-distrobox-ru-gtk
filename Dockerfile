FROM quay.io/toolbx/ubuntu-toolbox:26.04

ENV DEBIAN_FRONTEND=noninteractive

# 2. Настройка локалей (русский язык)
RUN locale-gen ru_RU.UTF-8
ENV LANG=ru_RU.UTF-8
ENV LC_ALL=ru_RU.UTF-8

# 3. Настройка репозиториев в НОВОМ ФОРМАТЕ (DEB822)
# Ubuntu 26.04 использует .sources файлы в /etc/apt/sources.list.d/
# вместо старого /etc/apt/sources.list
RUN mkdir -p /etc/apt/sources.list.d

# Создаем файл ubuntu.sources в формате YAML-like (DEB822)
# Используем зеркало ru.archive.ubuntu.com для скорости в РФ
RUN cat > /etc/apt/sources.list.d/ubuntu.sources << 'EOF'
Types: deb
URIs: http://ru.archive.ubuntu.com/ubuntu/
Suites: resolute resolute-updates resolute-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

# 5. Установка зависимостей для Distrobox (GTK + FreeDesktop)
# Мы ставим минимальный набор, чтобы контейнер был легким, но GUI работал.
RUN apt-get update && apt-get install -y --no-install-recommends \
    # GTK стеки (3 и 4 версии)
    libgtk-3-0 \
    libgtk-4-1 \
    \
    # FreeDesktop и интеграция с хостом
    xdg-utils \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    shared-mime-info \
    \
    # Системные шрифты (чтобы текст в приложениях не был "квадратами")
    fonts-noto-cjk \
    fonts-liberation \
    fonts-dejavu-core \
    \
    # D-Bus (нужен для многих сервисов)
    dbus-x11 \
    \
    # Удаление старых кэшей
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
