# Changelog

All notable changes to OCI Agent Skills will be documented in this file.

**Community Project**: OCI Agent Skills is a community-maintained project created and maintained by Alexander Cedergren. It is not an official Oracle product.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-01-26

### Added
- Community project status clarification and publication to Claude Code Marketplace
- Updated author information: Alexander Cedergren (alex@solutionsedge.io)
- Clear disclaimer that this is not an official Oracle product
- FinOps & Cost Optimization skill with advanced cost analysis
- 4 additional MCP servers for enhanced functionality:
  - OCI Pricing: Real-time SKU-based pricing lookups
  - OCI Usage: Cost and usage analytics for FinOps
  - OCI Resource Search: Cross-compartment resource discovery
  - OCI Cloud Guard: Security posture recommendations

### Enhanced
- Marketplace publication with proper schema configuration
- Plugin manifest with community-maintained status
- Documentation updated to reflect community authorship

### Technical
- Resolved marketplace schema validation issues
- Updated plugin JSON structure for Claude Code compatibility

## [1.1.0] - 2026-01-26

### Added
- Enhanced Generative AI Services skill
  - OCI OpenAI Package integration
  - Multi-provider agent building patterns (LangChain, LlamaIndex, AutoGen, Semantic Kernel, Vercel AI)
  - Advanced prompt engineering examples
  - RAG (Retrieval Augmented Generation) patterns

- Oracle Best Practices Skill
  - Well-Architected Framework principles
  - Operational excellence patterns
  - Reliability and high availability guidance
  - Performance optimization recommendations
  - Cost optimization strategies
  - Security and compliance best practices

### Enhanced
- GenAI skill with comprehensive model examples
- Added reference architectures for AI/ML workloads
- Expanded CIS OCI Foundations Benchmark coverage

## [1.0.0] - 2026-01-26

### Added

#### Best Practices Integration
- **OCI Best Practices Skill**: Official Oracle guidance from multiple authoritative sources
  - OCI Best Practices Guide integration
  - Oracle Solutions reference architectures
  - Oracle A-Team Chronicles technical content
  - Well-Architected Framework principles
  - CIS OCI Foundations Benchmark compliance

#### Core Skills
- **Compute Management**: Comprehensive CLI commands for VM and bare metal instance operations
  - Instance lifecycle (launch, stop, terminate, reboot)
  - VNIC management and networking
  - Console access for troubleshooting
  - Shape and image selection guidance

- **Networking Management**: Complete VCN and security configuration
  - VCN, subnet, and gateway creation
  - Security lists and Network Security Groups (NSG)
  - Route table configuration
  - CIDR planning and best practices

- **Database Management**: Full database service coverage
  - Autonomous Database (ATP/ADW) operations
  - DB Systems and RAC configuration
  - Backup and clone operations
  - PDB management
  - Wallet and connection management

- **Monitoring Operations**: Complete observability stack
  - Metrics queries for all OCI services
  - Alarm configuration and notifications
  - Log collection and search
  - Event rules and automation

- **Secrets Management**: OCI Vault integration
  - Vault and encryption key management
  - Secret creation and rotation
  - Secure credential retrieval
  - Application integration examples

- **Generative AI Services**: OCI GenAI platform support
  - Foundation model access (Cohere, Llama)
  - Text generation and chat completion
  - Embeddings for semantic search
  - Model fine-tuning workflows

- **IAM & Identity Management**: Complete access control
  - User, group, and policy management
  - Dynamic groups for instance principals
  - IDCS integration and SSO
  - Access troubleshooting

- **Infrastructure as Code**: Terraform and Resource Manager
  - Complete terraform-provider-oci examples
  - OCI Landing Zones integration
  - Resource Manager stack operations
  - Multi-region and multi-environment patterns

#### Agent & MCP Integration
- **OCI Cloud Architect Agent**: Multi-skill orchestrator for complex scenarios
  - End-to-end architecture design
  - Cross-service coordination
  - Best practices enforcement

- **MCP Server Integration**:
  - `oci-api`: Direct Oracle Cloud API access
  - `context7`: Live OCI documentation retrieval

#### Documentation
- Comprehensive README with usage examples
- Quick start guide for 5-minute setup
- Detailed skill references (1000+ CLI commands per skill)
- Troubleshooting guides
- Best practices for security, cost, and performance

### Features
- Auto-activation based on keywords and context
- Over 800 complete OCI CLI command examples
- Python SDK integration examples
- IAM policy templates for every service
- Multi-service workflow coordination
- Real-time documentation via Context7
- Production-ready security patterns

### Security
- Secure-by-default configurations
- Vault integration for credentials
- Least-privilege IAM examples
- Network security best practices
- Encryption at rest and in transit

### Performance
- Cost optimization guidance
- Right-sizing recommendations
- Caching strategies
- Performance tuning patterns

## [Unreleased]

### Planned for 1.3.0
- Container and Kubernetes (OKE) management skill
- Functions and serverless operations
- API Gateway configuration
- Data integration and streaming services

### Planned for 1.4.0
- Visual architecture diagram generation
- Multi-cloud comparison (OCI vs AWS vs Azure)
- Migration planning and assessment tools
- Disaster recovery and business continuity automation

---

## Version History Summary

**Community-Maintained Project by Alexander Cedergren**

- **1.2.0** (2026-01-26): Community clarification, marketplace publication, FinOps skill, additional MCP servers
- **1.1.0** (2026-01-26): Enhanced GenAI integration, Oracle best practices skill
- **1.0.0** (2026-01-26): Initial release with 8 skills, MCP integration, comprehensive documentation
