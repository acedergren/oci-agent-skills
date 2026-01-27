# Baseline Test: Secrets Management + GenAI Integration (No Skills)

## Scenario

A healthcare startup is building an AI medical transcription service using OCI GenAI. Their Python application runs on OCI compute instances and needs to call the GenAI inference API to process patient notes.

**Security audit finding:** "API keys are stored in environment variables. This is a security risk and must be moved to OCI Vault immediately."

**Requirements:**
- Move GenAI API credentials to OCI Vault
- Application must retrieve secrets securely at runtime
- Support secret rotation without application restart
- Must work on OCI compute instances (production) and developer laptops (local testing)
- Audit logging for secret access
- Cost-effective (don't retrieve secret on every API call)

**Timeline Pressure:** "Security team says we have 48 hours to fix this before they escalate to CTO."

**Existing Code:**
```python
# Current (insecure) implementation
import oci
import os

genai_client = oci.generative_ai_inference.GenerativeAiInferenceClient(
    config={
        'user': os.environ['OCI_USER_OCID'],
        'fingerprint': os.environ['OCI_FINGERPRINT'],
        'key_file': os.environ['OCI_KEY_FILE'],
        'tenancy': os.environ['OCI_TENANCY_OCID'],
        'region': 'us-chicago-1'
    }
)

def transcribe_note(medical_note: str) -> str:
    response = genai_client.chat(
        chat_request=oci.generative_ai_inference.models.ChatDetails(
            compartment_id=os.environ['OCI_COMPARTMENT_OCID'],
            serving_mode=oci.generative_ai_inference.models.OnDemandServingMode(
                model_id="cohere.command-r-plus"
            ),
            chat_request=oci.generative_ai_inference.models.CohereChatRequest(
                message=f"Transcribe and structure this medical note: {medical_note}",
                max_tokens=2000
            )
        )
    )
    return response.data.chat_response.text
```

## Tasks

Developer asks you:

1. **"How do I move these credentials to OCI Vault?"**
   - What goes in Vault vs what stays in environment variables?
   - What's the command to create the vault and store secrets?
   - How do I organize secrets (separate secrets vs bundle)?

2. **"How does my application authenticate to Vault to retrieve the secrets?"**
   - On OCI compute instances (production)
   - On developer laptops (local testing)
   - What IAM policies are needed?

3. **"How do I retrieve the secret in my Python code?"**
   - Show the code changes needed
   - How do I cache secrets (not retrieve on every API call)?
   - How do I handle secret retrieval failures?

4. **"What about secret rotation?"**
   - How do I rotate the GenAI API credentials?
   - Does my application need to detect new secret versions?
   - How do I do zero-downtime rotation?

5. **"How do I know if someone unauthorized is trying to access our secrets?"**
   - Audit logging setup
   - Monitoring and alerting

## Expected Agent Behaviors to Document

**WITHOUT the skills, agents typically:**

### Secrets Management Gaps:
- ❌ Don't know difference between Vault and Secrets (suggest "vault create" when it's "vault-secret create")
- ❌ Store entire config bundle as one secret (inefficient, hard to rotate)
- ❌ Don't mention instance principals for compute instances
- ❌ Retrieve secret on every API call (expensive, slow)
- ❌ No caching strategy or TTL considerations
- ❌ Missing IAM policies for secret access
- ❌ Don't set up secret rotation properly
- ❌ Forget audit logging configuration

### GenAI Integration Gaps:
- ❌ Don't optimize for cost (cache model responses, use cheaper models when appropriate)
- ❌ No error handling for rate limits or quota exceeded
- ❌ Don't mention token limits and truncation issues
- ❌ Miss prompt engineering best practices for medical domain
- ❌ No validation of GenAI responses
- ❌ Don't warn about PHI/PII handling in prompts

### Security Anti-Patterns:
- ❌ Log secrets accidentally in error messages
- ❌ Store secrets in code comments "temporarily"
- ❌ Use overly broad IAM policies ("any-user can read secret")
- ❌ Don't encrypt secrets at rest (Vault does this, but need to mention)
- ❌ Hardcode vault OCID in code (should be in config)

## Document Specifically:

1. **Vault Setup**
   - Command accuracy (vault vs secret vs key)
   - IAM policy completeness
   - Secret organization strategy

2. **Authentication Approach**
   - Do they mention instance principals?
   - Do they handle both production and dev environments?
   - Policy least-privilege or overly broad?

3. **Code Implementation**
   - Do they cache secrets?
   - Error handling quality
   - Secret version management

4. **Rotation Strategy**
   - Do they understand active vs previous versions?
   - Zero-downtime approach?
   - Application restart needed?

5. **Security Considerations**
   - Audit logging mentioned?
   - Encryption at rest/transit?
   - Least-privilege policies?

## Success Criteria (for AFTER skills are loaded)

Agent should:

1. **Vault Setup:**
   - Distinguish vault (container) vs secret (content) vs encryption key
   - Create vault with proper IAM policies
   - Store secrets separately (user_ocid, fingerprint, key_content as individual secrets)
   - Set up audit logging from the start

2. **Authentication:**
   - Recommend instance principals for compute instances
   - Provide OCI config file approach for local dev
   - Show minimal IAM policies (not "allow any-user")
   - Explain dynamic groups for instance principals

3. **Code Implementation:**
   - Cache secrets with TTL (e.g., 5 minutes)
   - Retrieve secret once per TTL, not per API call
   - Handle secret retrieval errors gracefully
   - Support secret version updates without restart

4. **Rotation:**
   - Create new secret version (not new secret)
   - Application reads latest version automatically
   - Keep previous version active during transition
   - No application restart needed

5. **Security:**
   - Enable Vault audit logging
   - Create alarms for unauthorized access attempts
   - Encrypt secrets at rest with customer-managed keys
   - Never log secret contents

6. **GenAI Best Practices:**
   - Mention token limits (command-r-plus: 128k input)
   - Cost optimization (cache responses, use Cohere Embed for semantic search)
   - Rate limit handling (exponential backoff)
   - PHI handling warnings (don't send actual patient names/IDs to model)

## Common Mistakes to Look For

1. **Conflating Vault concepts:**
   - "oci vault create" (correct)
   - "oci vault secret create" (correct)
   - "oci vault-secret create" (WRONG - no such command)

2. **Poor secret organization:**
   - Storing entire JSON config as one secret (hard to rotate individual fields)
   - Not using secret bundle base64 encoding properly

3. **Missing instance principals:**
   - Using user credentials on compute instances
   - Not setting up dynamic groups

4. **Inefficient secret retrieval:**
   - Calling Vault API on every GenAI inference request
   - No caching or TTL strategy

5. **Incorrect rotation:**
   - Deleting old secret and creating new one (causes downtime)
   - Not using secret versions properly

6. **Security gaps:**
   - Logging secret contents in error messages
   - Overly broad IAM policies
   - No audit logging enabled

## Pressure Elements

- **Time pressure:** 48-hour deadline from security team
- **Production impact:** Application is live, processing medical records
- **Compliance risk:** Healthcare data, HIPAA considerations
- **Authority pressure:** "CTO will escalate if not fixed"
- **Cost pressure:** GenAI API calls are expensive (~$15/million tokens)
- **Complexity:** Multiple services (Vault, GenAI, IAM, Compute)

## Real-World Context

This scenario mirrors actual production issues:
- Secrets in environment variables is a common anti-pattern
- Healthcare AI apps face regulatory scrutiny
- Cost optimization for GenAI is critical (can be $1000s/month)
- Secret rotation often breaks applications if not designed properly
- Developers struggle with instance principals vs user principals

This should expose significant knowledge gaps that the skills are meant to fill.
