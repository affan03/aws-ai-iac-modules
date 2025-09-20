# AWS AI Infrastructure as Code Modules

A collection of Terraform modules for deploying and managing AWS AI/ML services with best practices, security, and enterprise-ready configurations.

## 🚀 Features

- ✅ **Production-Ready**: Enterprise-grade configurations with security best practices
- 🔐 **Security First**: IAM roles, encryption, and access controls built-in
- 📊 **Monitoring**: CloudWatch integration and comprehensive logging
- 🏷️ **Standardized**: Consistent tagging and naming conventions
- 📚 **Well-Documented**: Complete examples and usage guides

## 📦 Available Modules

| Module | Service | Status | Description |
|--------|---------|--------|-------------|
| [`kendra`](./kendra/) | Amazon Kendra | ✅ Available | Enterprise search with S3 and web crawler support |
| `bedrock` | Amazon Bedrock | 🚧 Coming Soon | Generative AI foundation models |
| `comprehend` | Amazon Comprehend | 🚧 Coming Soon | Natural language processing |
| `textract` | Amazon Textract | 🚧 Coming Soon | Document text extraction |
| `rekognition` | Amazon Rekognition | 🚧 Coming Soon | Image and video analysis |
| `polly` | Amazon Polly | 🚧 Coming Soon | Text-to-speech service |
| `transcribe` | Amazon Transcribe | 🚧 Coming Soon | Speech-to-text service |
| `translate` | Amazon Translate | 🚧 Coming Soon | Language translation service |
| `personalize` | Amazon Personalize | 🚧 Coming Soon | ML-powered recommendations |
| `forecast` | Amazon Forecast | 🚧 Coming Soon | Time-series forecasting |

## 🏗️ Module Structure

Each module follows a consistent structure:

```
module-name/
├── main.tf              # Main resources
├── variables.tf         # Input variables
├── outputs.tf          # Output values
├── examples/           # Usage examples
│   ├── basic/
│   ├── advanced/
│   └── enterprise/
├── test/               # Test configurations
└── README.md           # Module documentation
```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/your-org/aws-ai-iac-modules.git
cd aws-ai-iac-modules
```

### 2. Choose a Module
```bash
cd kendra  # or any other module
```

### 3. Review Examples
```bash
ls examples/
# basic/  advanced/  enterprise/
```

### 4. Deploy
```hcl
module "ai_service" {
  source = "github.com/your-org/aws-ai-iac-modules//kendra"
  
  # Module-specific configuration
  # See individual module README for details
}
```

## 📋 Prerequisites

- **Terraform**: >= 1.0
- **AWS Provider**: >= 4.0
- **AWS CLI**: Configured with appropriate permissions
- **Valid AWS Account** with AI service quotas

## 🔧 Common Variables

Most modules support these standard variables:

| Variable | Type | Description |
|----------|------|-------------|
| `name` | `string` | Resource name |
| `environment` | `string` | Environment (dev/staging/prod) |
| `tags` | `map(string)` | Resource tags |
| `kms_key_id` | `string` | KMS key for encryption |

## 🏷️ Tagging Strategy

All modules implement consistent tagging:

```hcl
tags = {
  Environment   = "production"
  Module        = "kendra"
  ManagedBy     = "terraform"
  CostCenter    = "ai-ml"
  Project       = "enterprise-search"
  Owner         = "data-team"
}
```

## 🔒 Security Best Practices

- **IAM Roles**: Least-privilege access with automatic role creation
- **Encryption**: KMS encryption at rest and in transit
- **VPC Integration**: Private subnet deployments where applicable
- **Access Controls**: Resource-based policies and conditions
- **Audit Logging**: CloudTrail and service-specific logging

## 📊 Monitoring & Observability

- **CloudWatch Metrics**: Service-specific metrics and dashboards
- **CloudWatch Logs**: Centralized logging with structured formats
- **AWS X-Ray**: Distributed tracing for supported services
- **Cost Tracking**: Resource-level cost allocation tags

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/new-module`)
3. **Follow** the module structure and conventions
4. **Add** comprehensive examples and tests
5. **Update** this README with new modules
6. **Submit** a Pull Request

### Module Development Guidelines

- Use consistent variable naming and descriptions
- Include validation rules where appropriate
- Provide basic, advanced, and enterprise examples
- Add comprehensive README documentation
- Include test configurations
- Follow Terraform best practices

## 📚 Documentation

Each module includes:
- **README.md**: Complete usage guide
- **variables.tf**: All input parameters
- **outputs.tf**: Return values
- **examples/**: Working example configurations

## 🆘 Support

- 📖 **Documentation**: Check individual module READMEs
- 🐛 **Issues**: [GitHub Issues](https://github.com/your-org/aws-ai-iac-modules/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/your-org/aws-ai-iac-modules/discussions)
- 📧 **Contact**: ai-platform-team@company.com

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Maintained by**: AI Platform Team  
**Last Updated**: September 2025  
**Terraform Version**: >= 1.0  
**AWS Provider**: >= 4.0
