# AWS AI Infrastructure as Code Modules

A collection of Terraform modules for deploying and managing AWS AI/ML services with best practices, security, and enterprise-ready configurations.

## 🚀 Features

- ✅ **Production-Ready**: Enterprise-grade configurations with security best practices
- 🔐 **Security First**: IAM roles, encryption, and access controls built-in
- 📊 **Monitoring**: CloudWatch integration and comprehensive logging
- 🏷️ **Standardized**: Consistent tagging and naming conventions
- 📚 **Well-Documented**: Complete examples and usage guides
- 🔄 **Lifecycle Management**: Automated resource creation and dependency handling

## 📦 Available Modules

| Module | Service | Status | Description |
|--------|---------|--------|-------------|
| [`kendra`](./aws-kendra-data-source/) | Amazon Kendra | ✅ Available | Enterprise search with S3 and web crawler support |
| [`comprehend`](./aws-comprehend/) | Amazon Comprehend | ✅ Available | Natural language processing with custom models |
| [`bedrock`](./aws-bedrock/) | Amazon Bedrock | ✅ Available | Generative AI foundation models |
| [`textract`](./aws-textract/) | Amazon Textract | ✅ Available | Document text extraction |
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
├── iam.tf              # IAM roles and policies (where applicable)
├── variables.tf         # Input variables with validation
├── outputs.tf          # Output values
├── versions.tf         # Provider requirements
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
cd aws-kendra-data-source  # Enterprise search
cd aws-comprehend          # Natural language processing
cd aws-bedrock             # Generative AI foundation models
cd aws-textract            # Document text extraction
```

### 3. Review Examples
```bash
ls examples/
# basic/  advanced/  enterprise/
```

### 4. Deploy
```hcl
# Kendra Search Index
module "enterprise_search" {
  source = "github.com/your-org/aws-ai-iac-modules//aws-kendra-data-source"
  
  kendra_index_name    = "company-docs"
  kendra_data_source_type = "S3"
  s3_bucket_name       = "company-documents"
}

# Comprehend Document Classifier  
module "document_classifier" {
  source = "github.com/your-org/aws-ai-iac-modules//aws-comprehend"
  
  name             = "sentiment-classifier"
  resource_type    = "classifier"
  s3_bucket_name   = "ml-training-data"
  input_s3_uri     = "s3://ml-training-data/reviews.csv"
}

# Bedrock Custom Model
module "custom_model" {
  source = "github.com/your-org/aws-ai-iac-modules//aws-bedrock"
  
  name                 = "my-custom-model"
  resource_type        = "custom_model"
  base_model_identifier = "amazon.titan-text-express-v1"
  s3_bucket_name       = "bedrock-training-data"
  training_data_config = {
    s3_uri = "s3://bedrock-training-data/training/dataset.jsonl"
  }
}

# Textract Adapter
module "textract_adapter" {
  source = "github.com/your-org/aws-ai-iac-modules//aws-textract"
  
  name          = "invoice-adapter"
  resource_type = "adapter"
  s3_bucket_name = "textract-documents"
  adapter_versions = [{
    version_name = "v1"
    dataset_config = {
      manifest_s3_object = {
        bucket = "training-data"
        name   = "manifests/invoice-manifest.json"
      }
    }
  }]
}
```

## 📋 Prerequisites

- **Terraform**: >= 1.0 (1.5+ recommended)
- **AWS Provider**: >= 4.0 (5.0+ recommended)
- **AWS CLI**: Configured with appropriate permissions
- **Valid AWS Account** with AI service quotas
- **S3 Bucket**: For training data and model artifacts

## 🔧 Common Variables

Most modules support these standard variables:

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | `string` | - | Resource name |
| `environment` | `string` | - | Environment (dev/staging/prod) |
| `tags` | `map(string)` | `{}` | Resource tags |
| `kms_key_id` | `string` | `null` | KMS key for encryption |
| `s3_bucket_name` | `string` | - | S3 bucket for data/models |
| `language_code` | `string` | `"en"` | Primary language code |

## 🎯 Module-Specific Features

### Amazon Kendra
- ✅ **Search Indices**: Enterprise-grade document search
- 📁 **S3 Data Sources**: Direct integration with S3 buckets  
- 🕷️ **Web Crawler**: Crawl websites and APIs
- 🔐 **Access Control**: JWT tokens and ACL support
- 📊 **Custom Metadata**: Relevance tuning and faceting

### Amazon Comprehend  
- 🏷️ **Document Classification**: Custom text categorization
- 🔍 **Entity Recognition**: Extract custom entities from text
- 🌐 **Multi-Language**: Support for 10+ languages
- 🤖 **Auto-IAM**: Automatic role creation with least privilege
- 📈 **Production Ready**: Lifecycle management and validation

### Amazon Bedrock
- 🤖 **Custom Models**: Fine-tune foundation models for specific use cases
- 🛡️ **Guardrails**: Content filtering and safety controls
- 📚 **Knowledge Bases**: RAG with vector storage (OpenSearch, Pinecone, RDS)
- 📊 **Logging**: Comprehensive logging for model invocations
- 🔐 **Auto-IAM**: Automatic role creation with least privilege
- 📈 **Production Ready**: Enterprise-grade configurations

### Amazon Textract
- 📄 **Custom Adapters**: Create specialized document processing adapters
- 🔍 **Feature Types**: Extract text, forms, tables, queries, signatures, and layout
- 📁 **S3 Integration**: Seamless document input and result output
- 🔐 **Auto-IAM**: Automatic role creation with least privilege
- 📈 **Production Ready**: Enterprise-grade configurations

## 🏷️ Tagging Strategy

All modules implement consistent tagging:

```hcl
tags = {
  Environment   = "production"
  Module        = "kendra"           # or "comprehend"
  ManagedBy     = "terraform"
  CostCenter    = "ai-ml"
  Project       = "enterprise-search"
  Owner         = "data-team"
  DataClass     = "internal"         # internal/confidential/public
  BackupPolicy  = "required"         # required/optional
}
```

## 🔒 Security Best Practices

### IAM & Access Control
- **Automatic IAM Roles**: Least-privilege access with service-specific permissions
- **Cross-Service Access**: Secure integration between AWS services  
- **Resource-Based Policies**: Fine-grained access control
- **Assume Role Policies**: Proper service-to-service authentication

### Data Protection
- **Encryption at Rest**: KMS encryption for all data storage
- **Encryption in Transit**: TLS/SSL for all data transmission
- **S3 Server-Side Encryption**: AES256 encryption requirements
- **Access Logging**: Comprehensive audit trails

### Network Security
- **VPC Integration**: Private subnet deployments where applicable
- **Security Groups**: Restrictive ingress/egress rules
- **Endpoint Configuration**: VPC endpoints for AWS services
- **Network ACLs**: Additional network-level controls

## 📊 Monitoring & Observability

### CloudWatch Integration
- **Custom Metrics**: Service-specific performance indicators
- **Automated Dashboards**: Pre-configured monitoring views
- **Log Aggregation**: Centralized logging with structured formats
- **Alerting**: Proactive monitoring and notification

### Cost Management
- **Resource Tagging**: Detailed cost allocation and tracking
- **Usage Monitoring**: Real-time usage and cost metrics
- **Optimization Alerts**: Notifications for cost anomalies
- **Lifecycle Policies**: Automated cleanup of temporary resources

### Performance Tracking
- **Query Latency**: Response time monitoring (Kendra)
- **Training Duration**: Model training time tracking (Comprehend)
- **Success Rates**: Operation success/failure metrics
- **Capacity Utilization**: Resource usage optimization

## 💰 Cost Considerations

### Kendra Pricing
- **Developer Edition**: $810/month for up to 750 hours of usage
- **Enterprise Edition**: $1,008/month + capacity units
- **Query Capacity**: $0.40/hour per additional unit
- **Storage Capacity**: $2.50/hour per additional unit

### Comprehend Pricing  
- **Training Jobs**: $3.00 per job + $0.50/hour training time
- **Real-time Inference**: $0.0005 per 100 characters
- **Batch Processing**: $0.0001 per 100 characters  
- **Custom Model Hosting**: $0.50/hour

### Cost Optimization Tips
- 🏷️ Use consistent tagging for cost allocation
- 📊 Monitor usage with CloudWatch metrics
- 🔄 Implement lifecycle policies for temporary data
- 📈 Start with smaller configurations and scale up
- 🎯 Use batch processing for large document sets

## 🧪 Testing & Validation

### Module Testing
```bash
# Validate Terraform syntax
terraform validate

# Format code
terraform fmt -recursive

# Plan deployment
terraform plan

# Run basic tests
cd test/
terraform init && terraform plan
```

### Integration Testing
- **End-to-End**: Full deployment and functionality testing  
- **Security Scanning**: IAM policy and resource configuration validation
- **Performance Testing**: Load testing for production scenarios
- **Cost Validation**: Verify expected resource costs

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### 1. Development Workflow
1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/new-module`)
3. **Develop** following our module conventions
4. **Test** thoroughly with multiple scenarios
5. **Document** all changes and new features
6. **Submit** a Pull Request with detailed description

### 2. Module Development Guidelines

#### Code Standards
- Follow HashiCorp Configuration Language (HCL) best practices
- Use consistent variable naming and descriptions
- Include comprehensive validation rules
- Implement proper error handling and lifecycle management

#### Documentation Requirements
- Complete README.md with usage examples
- Variable descriptions and validation rules  
- Output descriptions and example values
- Troubleshooting guide with common issues

#### Testing Requirements
- Basic configuration test
- Advanced feature test  
- Enterprise scenario test
- IAM role validation test

#### Security Requirements
- Least-privilege IAM policies
- Encryption at rest and in transit
- Proper resource isolation
- Security best practice documentation

### 3. Adding New Modules

When adding a new AWS AI/ML service module:

1. **Create Module Structure**
   ```bash
   mkdir new-service
   cd new-service
   touch main.tf variables.tf outputs.tf versions.tf README.md
   mkdir -p examples/{basic,advanced,enterprise} test/
   ```

2. **Update Main README**
   - Add module to the Available Modules table
   - Update any relevant sections
   - Add service-specific features if significant

3. **Follow Naming Conventions**
   - Use AWS service names (lowercase, no hyphens)
   - Consistent variable naming across modules
   - Standard output naming patterns

4. **Include Required Elements**
   - IAM role automation (where applicable)
   - Encryption support
   - Tagging strategy
   - Validation rules
   - Examples for all complexity levels

## 📚 Documentation

### Per-Module Documentation
Each module includes:
- **README.md**: Complete usage guide with examples
- **variables.tf**: Comprehensive input parameters with validation
- **outputs.tf**: All return values with descriptions  
- **examples/**: Working configurations for different use cases

### Repository Documentation
- **This README**: Overview and getting started guide
- **CONTRIBUTING.md**: Detailed contribution guidelines
- **CHANGELOG.md**: Version history and breaking changes
- **LICENSE**: Project license information

## 🔗 Related Resources

### AWS Documentation
- [AWS AI/ML Services](https://aws.amazon.com/machine-learning/)
- [Amazon Kendra Developer Guide](https://docs.aws.amazon.com/kendra/)
- [Amazon Comprehend Developer Guide](https://docs.aws.amazon.com/comprehend/)
- [Amazon Bedrock Developer Guide](https://docs.aws.amazon.com/bedrock/)
- [Amazon Textract Developer Guide](https://docs.aws.amazon.com/textract/)

### Terraform Resources
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)
- [HashiCorp Configuration Language](https://www.terraform.io/docs/language/index.html)

### Community
- [AWS AI/ML Blog](https://aws.amazon.com/blogs/machine-learning/)
- [Terraform Community](https://discuss.hashicorp.com/c/terraform-core/)
- [GitHub Issues](https://github.com/your-org/aws-ai-iac-modules/issues)

---

**Version**: 1.1.0  
**Last Updated**: September 2025  
**Terraform Version**: >= 1.0  
**AWS Provider Version**: >= 4.0  

**License**: MIT  
**Maintainer**: AI/ML Infrastructure Team  
**Support**: Create an issue for questions or bug reports