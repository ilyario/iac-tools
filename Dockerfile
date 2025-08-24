# Используем Alpine Linux как базовый образ для минимального размера
FROM alpine:3.19

# Определяем build arguments для версий
ARG KUBECTL_VERSION=v1.33.0
ARG HELM_VERSION=v3.14.0
ARG HELMFILE_VERSION=v1.1.5
ARG AH_HELM_CHARTS_VERSION=1.0.1

# Устанавливаем необходимые пакеты
RUN apk add --no-cache \
    curl \
    bash \
    git \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Устанавливаем kubectl
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Устанавливаем Helm
RUN curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar xz \
    && mv linux-amd64/helm /usr/local/bin/ \
    && rm -rf linux-amd64

# Устанавливаем helm-diff плагин
RUN helm plugin install https://github.com/databus23/helm-diff

RUN curl -fsSL -o /tmp/helmfile.tar.gz \
    "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzf /tmp/helmfile.tar.gz -C /tmp && \
    mv /tmp/helmfile /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/helmfile && \
    rm -rf /tmp/helmfile.tar.gz /tmp/helmfile

# Создаем рабочую директорию
WORKDIR /workspace

# Создаем директорию для charts
RUN mkdir -p /workspace/charts

# Устанавливаем bash как оболочку по умолчанию
SHELL ["/bin/bash", "-c"]

# Проверяем установку всех инструментов
RUN kubectl version --client && \
    helm version && \
    helm plugin list | grep diff && \
    helmfile version

# Клонируем helm charts репозиторий и копируем только папку charts
RUN git clone --depth 1 --branch ${AH_HELM_CHARTS_VERSION} https://github.com/ilyario/ah-helm-charts.git /tmp/charts-repo && \
    cp -r /tmp/charts-repo/charts/* /workspace/charts/ && \
    rm -rf /tmp/charts-repo

# Команда по умолчанию
CMD ["/bin/bash"]
