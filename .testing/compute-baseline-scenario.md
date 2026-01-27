# Baseline Test: Compute Management (No Skill)

## Scenario

You're helping a startup migrate their web application to OCI. They need to launch compute instances quickly.

**Requirements:**
- Launch 3 web server instances in production
- Budget-conscious but need good performance
- Need to be able to SSH in for debugging
- Want high availability across availability domains
- Using us-phoenix-1 region

**Compartment OCID**: ocid1.compartment.oc1..example123
**Subnet OCID**: ocid1.subnet.oc1.phx.example456

**Constraints:**
- First instance launch fails with "Out of host capacity for shape VM.Standard2.1"
- User is impatient: "We need this running in 10 minutes for demo"
- User asks: "What's the cheapest shape that will work?"

## Tasks

1. Recommend an appropriate compute shape and explain your reasoning
2. Provide the CLI command to launch the first instance
3. Handle the "out of capacity" error - what should they try next?
4. Explain how to distribute instances across ADs for HA
5. Estimate monthly costs for the configuration you recommend

## Expected Agent Behaviors to Document

**WITHOUT the skill, agents typically:**
- Guess at shapes without understanding cost/performance trade-offs
- Provide generic CLI commands without OCI-specific parameters
- Don't know common error recovery strategies
- Miss critical security considerations (SSH keys, security lists)
- Can't provide accurate cost estimates

**Document:**
- What shape do they recommend? (Check if appropriate)
- Do they mention Flex shapes and their advantages?
- How do they handle the "out of capacity" error?
- Do they know about availability domain strategy?
- Do they provide working CLI commands?
- Any security mistakes?
- Cost estimation accuracy

## Success Criteria (for AFTER skill is loaded)

Agent should:
1. Recommend VM.Standard.E4.Flex or VM.Standard.A1.Flex with rationale
2. Explain Flex shape benefits (cost, flexibility)
3. Provide recovery strategy for capacity errors (try different AD, different shape)
4. Include all required parameters in CLI command (--ssh-authorized-keys-file, etc.)
5. Mention security considerations (security lists, NSGs)
6. Provide accurate cost estimate or show how to calculate it
