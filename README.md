# Move to https://github.com/ilyario/ah-helm-charts

# IAC Tools Docker Image

A Docker image with tools for working with Kubernetes and Helm:

- **kubectl** - CLI for managing Kubernetes clusters
- **helm** - package manager for Kubernetes
- **helm-diff** - Helm plugin for showing differences between releases
- **helmfile** - declarative way to manage Helm releases

## Quick Start

### Using the pre-built image

```bash
docker run -it --rm ghcr.io/your-username/iac-tools:latest
```

### Building locally

```bash
# Build with default versions
docker build -t iac-tools .

# Build with specific versions
docker build \
  --build-arg KUBECTL_VERSION=v1.33.0 \
  --build-arg HELM_VERSION=v3.13.0 \
  --build-arg HELMFILE_VERSION=v1.0.0 \
  -t iac-tools .
```

## Usage

### Interactive shell

```bash
docker run -it --rm iac-tools
```

### Mount current directory

```bash
docker run -it --rm -v $(pwd):/workspace iac-tools
```

### Using kubectl

```bash
docker run -it --rm -v ~/.kube:/root/.kube iac-tools kubectl get pods
```

### Using helm

```bash
docker run -it --rm -v ~/.kube:/root/.kube iac-tools helm list
```

### Using helmfile

```bash
docker run -it --rm -v $(pwd):/workspace -v ~/.kube:/root/.kube iac-tools helmfile apply
```

### Using included helm charts

```bash
# List available charts
docker run -it --rm iac-tools ls -la /workspace/charts

# Install a chart from the included repository
docker run -it --rm -v ~/.kube:/root/.kube iac-tools helm install my-release /workspace/charts/my-chart
```



## Verify installed tools

```bash
# Check kubectl version
docker run --rm iac-tools kubectl version --client

# Check helm version
docker run --rm iac-tools helm version

# Check installed helm plugins
docker run --rm iac-tools helm plugin list

# Check helmfile version
docker run --rm iac-tools helmfile version
```

## Environment Variables

The image supports standard environment variables for kubectl and helm:

- `KUBECONFIG` - path to kubectl configuration file
- `HELM_KUBECONFIG` - path to helm configuration file

## CI/CD Examples

### GitHub Actions

```yaml
- name: Deploy with helmfile
  run: |
    docker run --rm \
      -v ${{ github.workspace }}:/workspace \
      -v $HOME/.kube:/root/.kube \
      -e KUBECONFIG=/root/.kube/config \
      ghcr.io/your-username/iac-tools:latest helmfile apply
```

### GitLab CI

```yaml
deploy:
  image: ghcr.io/your-username/iac-tools:latest
  script:
    - helmfile apply
  before_script:
    - echo "$KUBECONFIG" | base64 -d > /root/.kube/config
```

## Included Tools

| Tool | Version | Description |
|------|---------|-------------|
| kubectl | Configurable (default: v1.33.0) | Kubernetes command-line tool |
| helm | Configurable (default: v3.14.0) | Kubernetes package manager |
| helm-diff | Latest | Helm plugin for diffing releases |
| helmfile | Configurable (default: v1.1.5) | Declarative Helm deployments |

## Helm Charts

The image includes helm charts from the repository `https://github.com/ilyario/ah-helm-charts.git`. Only the contents of the `charts/` directory are copied to `/workspace/charts` in the container.

### Version Control

You can specify versions for kubectl, Helm, and helmfile using build arguments:

- `KUBECTL_VERSION` - kubectl version (default: v1.33.0)
- `HELM_VERSION` - Helm version (default: v3.14.0)
- `HELMFILE_VERSION` - helmfile version (default: v1.1.5)

## Security

This image is automatically scanned for vulnerabilities using:
- Trivy vulnerability scanner
- Hadolint for Dockerfile best practices

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.
