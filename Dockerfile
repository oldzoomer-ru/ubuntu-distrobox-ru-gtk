FROM quay.io/toolbx/ubuntu-toolbox:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Создаем файл ubuntu.sources в формате YAML-like (DEB822)
# Используем зеркало ru.archive.ubuntu.com для скорости в РФ
RUN cat > /etc/apt/sources.list.d/ubuntu.sources << 'EOF'
Types: deb
URIs: http://ru.archive.ubuntu.com/ubuntu/
Suites: resolute resolute-updates resolute-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

# Установка зависимостей для Distrobox (GTK + FreeDesktop)
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
