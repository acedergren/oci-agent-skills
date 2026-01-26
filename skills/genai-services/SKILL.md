---
name: OCI Generative AI Services
description: Expert in Oracle Cloud Infrastructure Generative AI services including foundation models, embeddings, chat, text generation, and fine-tuning. Complete CLI and SDK reference.
version: 1.0.0
---

# OCI Generative AI Services Skill

You are an expert in Oracle Cloud Infrastructure Generative AI services. This skill provides comprehensive CLI commands, SDK examples, and best practices for using OCI's GenAI capabilities to compensate for Claude's limited OCI training data.

## Core GenAI Services

### Foundation Models
- Pre-trained large language models (LLMs)
- Cohere Command models for chat and generation
- Meta Llama models
- Model fine-tuning and customization

### Inference Endpoints
- Dedicated and on-demand inference endpoints
- Text generation and completion
- Chat completions with conversation history
- Embeddings for semantic search

### Fine-Tuning
- Custom model training on your data
- T-Few and vanilla fine-tuning methods
- Training data management
- Model versioning

## OCI GenAI CLI Commands

### Listing Available Models
```bash
# List all available foundation models
oci generative-ai model list \
  --compartment-id <compartment-ocid>

# Get model details
oci generative-ai model get \
  --model-id <model-ocid>

# List pre-trained models by capability
oci generative-ai model list \
  --compartment-id <compartment-ocid> \
  --capability TEXT_GENERATION

# List chat models
oci generative-ai model list \
  --compartment-id <compartment-ocid> \
  --capability CHAT

# List embedding models
oci generative-ai model list \
  --compartment-id <compartment-ocid> \
  --capability EMBEDDINGS
```

### Dedicated AI Clusters (for hosting endpoints)
```bash
# List dedicated AI clusters
oci generative-ai dedicated-ai-cluster list \
  --compartment-id <compartment-ocid>

# Get cluster details
oci generative-ai dedicated-ai-cluster get \
  --dedicated-ai-cluster-id <cluster-ocid>

# Create dedicated AI cluster
oci generative-ai dedicated-ai-cluster create \
  --compartment-id <compartment-ocid> \
  --type FINE_TUNING \
  --unit-count 1 \
  --unit-shape LARGE_COHERE \
  --display-name "ProductionGenAICluster"

# Update cluster
oci generative-ai dedicated-ai-cluster update \
  --dedicated-ai-cluster-id <cluster-ocid> \
  --unit-count 2

# Delete cluster
oci generative-ai dedicated-ai-cluster delete \
  --dedicated-ai-cluster-id <cluster-ocid>
```

### Endpoints for Inference
```bash
# List endpoints
oci generative-ai endpoint list \
  --compartment-id <compartment-ocid>

# Get endpoint details
oci generative-ai endpoint get \
  --endpoint-id <endpoint-ocid>

# Create hosted endpoint
oci generative-ai endpoint create \
  --compartment-id <compartment-ocid> \
  --model-id <model-ocid> \
  --dedicated-ai-cluster-id <cluster-ocid> \
  --display-name "ChatEndpoint"

# Update endpoint
oci generative-ai endpoint update \
  --endpoint-id <endpoint-ocid> \
  --display-name "UpdatedEndpoint"

# Delete endpoint
oci generative-ai endpoint delete \
  --endpoint-id <endpoint-ocid>
```

## Text Generation via Inference API

### Using OCI CLI for Generation
```bash
# Generate text using foundation model (via inference)
oci generative-ai-inference generate-text \
  --serving-mode '{"servingType":"ON_DEMAND","modelId":"<model-ocid>"}' \
  --compartment-id <compartment-ocid> \
  --inference-request '{
    "prompt": "Explain quantum computing in simple terms",
    "maxTokens": 500,
    "temperature": 0.7,
    "topP": 0.9,
    "frequencyPenalty": 0.0,
    "presencePenalty": 0.0
  }'

# Generate with dedicated endpoint
oci generative-ai-inference generate-text \
  --serving-mode '{"servingType":"DEDICATED","endpointId":"<endpoint-ocid>"}' \
  --compartment-id <compartment-ocid> \
  --inference-request '{
    "prompt": "Write a Python function to sort a list",
    "maxTokens": 300,
    "temperature": 0.5
  }'
```

### Chat Completion
```bash
# Chat completion with conversation history
oci generative-ai-inference chat \
  --serving-mode '{"servingType":"ON_DEMAND","modelId":"<model-ocid>"}' \
  --compartment-id <compartment-ocid> \
  --chat-request '{
    "messages": [
      {"role": "system", "content": "You are a helpful coding assistant"},
      {"role": "user", "content": "How do I connect to an Oracle database in Python?"}
    ],
    "maxTokens": 500,
    "temperature": 0.7
  }'

# Multi-turn conversation
oci generative-ai-inference chat \
  --serving-mode '{"servingType":"ON_DEMAND","modelId":"<model-ocid>"}' \
  --compartment-id <compartment-ocid> \
  --chat-request '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant"},
      {"role": "user", "content": "What is OCI?"},
      {"role": "assistant", "content": "OCI stands for Oracle Cloud Infrastructure..."},
      {"role": "user", "content": "What services does it offer?"}
    ],
    "maxTokens": 600
  }'
```

### Embeddings Generation
```bash
# Generate embeddings for text
oci generative-ai-inference embed-text \
  --serving-mode '{"servingType":"ON_DEMAND","modelId":"<embedding-model-ocid>"}' \
  --compartment-id <compartment-ocid> \
  --embed-text-request '{
    "inputs": ["Oracle Cloud Infrastructure", "Generative AI"],
    "truncate": "END"
  }'

# Generate embeddings for semantic search
oci generative-ai-inference embed-text \
  --serving-mode '{"servingType":"ON_DEMAND","modelId":"<embedding-model-ocid>"}' \
  --compartment-id <compartment-ocid> \
  --embed-text-request '{
    "inputs": [
      "How do I create a compute instance?",
      "What is the price of block storage?",
      "Database backup procedures"
    ],
    "truncate": "END"
  }'
```

## Python SDK Examples

### Setup and Authentication
```python
import oci
from oci.generative_ai_inference import GenerativeAiInferenceClient
from oci.generative_ai_inference.models import (
    OnDemandServingMode,
    GenerateTextDetails,
    CohereLlmInferenceRequest,
    ChatDetails,
    CohereMessage,
    EmbedTextDetails
)

# Load OCI config
config = oci.config.from_file("~/.oci/config", "DEFAULT")

# Create GenAI inference client
genai_client = GenerativeAiInferenceClient(
    config=config,
    service_endpoint="https://inference.generativeai.us-chicago-1.oci.oraclecloud.com"
)
```

### Text Generation
```python
def generate_text(prompt, model_id, compartment_id):
    """Generate text using OCI GenAI"""

    # Configure serving mode (on-demand)
    serving_mode = OnDemandServingMode(model_id=model_id)

    # Create inference request
    inference_request = CohereLlmInferenceRequest(
        prompt=prompt,
        max_tokens=500,
        temperature=0.7,
        frequency_penalty=0.0,
        presence_penalty=0.0,
        top_p=0.9,
        top_k=0
    )

    # Create generate text details
    generate_text_detail = GenerateTextDetails(
        compartment_id=compartment_id,
        serving_mode=serving_mode,
        inference_request=inference_request
    )

    # Generate text
    response = genai_client.generate_text(generate_text_detail)

    # Extract generated text
    generated_text = response.data.inference_response.generated_texts[0].text
    return generated_text

# Usage
result = generate_text(
    prompt="Explain OCI networking concepts",
    model_id="ocid1.generativeaimodel.oc1.us-chicago-1...",
    compartment_id="ocid1.compartment.oc1..."
)
print(result)
```

### Chat Completion
```python
def chat_with_ai(messages, model_id, compartment_id):
    """Chat with AI using conversation history"""

    # Convert messages to Cohere format
    cohere_messages = []
    for msg in messages:
        cohere_messages.append(
            CohereMessage(
                role=msg["role"],
                message=msg["content"]
            )
        )

    # Configure serving mode
    serving_mode = OnDemandServingMode(model_id=model_id)

    # Create chat request
    chat_request = CohereChatRequest(
        message=messages[-1]["content"],  # Current message
        chat_history=cohere_messages[:-1],  # Previous messages
        max_tokens=500,
        temperature=0.7
    )

    # Create chat details
    chat_detail = ChatDetails(
        compartment_id=compartment_id,
        serving_mode=serving_mode,
        chat_request=chat_request
    )

    # Get response
    response = genai_client.chat(chat_detail)
    return response.data.chat_response.text

# Usage
conversation = [
    {"role": "system", "content": "You are a helpful OCI assistant"},
    {"role": "user", "content": "How do I create a VCN?"}
]

reply = chat_with_ai(
    messages=conversation,
    model_id="ocid1.generativeaimodel.oc1.us-chicago-1...",
    compartment_id="ocid1.compartment.oc1..."
)
print(reply)
```

### Generate Embeddings
```python
def generate_embeddings(texts, model_id, compartment_id):
    """Generate embeddings for semantic search"""

    # Configure serving mode
    serving_mode = OnDemandServingMode(model_id=model_id)

    # Create embed request
    embed_request = CohereEmbedTextRequest(
        inputs=texts,
        truncate="END"
    )

    # Create embed details
    embed_detail = EmbedTextDetails(
        compartment_id=compartment_id,
        serving_mode=serving_mode,
        embed_text_request=embed_request
    )

    # Generate embeddings
    response = genai_client.embed_text(embed_detail)

    # Extract embeddings
    embeddings = response.data.embed_text_result.embeddings
    return embeddings

# Usage for semantic search
documents = [
    "OCI compute instances provide flexible VM options",
    "Block storage offers high-performance persistent storage",
    "Autonomous Database is a fully managed service"
]

embeddings = generate_embeddings(
    texts=documents,
    model_id="ocid1.generativeaimodel.oc1.us-chicago-1...",
    compartment_id="ocid1.compartment.oc1..."
)

# Now you can use embeddings for similarity search
```

### Streaming Responses
```python
def generate_text_streaming(prompt, model_id, compartment_id):
    """Generate text with streaming response"""

    serving_mode = OnDemandServingMode(model_id=model_id)

    inference_request = CohereLlmInferenceRequest(
        prompt=prompt,
        max_tokens=500,
        temperature=0.7,
        is_stream=True  # Enable streaming
    )

    generate_text_detail = GenerateTextDetails(
        compartment_id=compartment_id,
        serving_mode=serving_mode,
        inference_request=inference_request
    )

    # Stream response
    response = genai_client.generate_text(generate_text_detail)

    # Process stream
    for chunk in response.data:
        if chunk.inference_response:
            text = chunk.inference_response.generated_texts[0].text
            print(text, end='', flush=True)

# Usage
generate_text_streaming(
    prompt="Write a detailed explanation of OCI services",
    model_id="ocid1.generativeaimodel.oc1.us-chicago-1...",
    compartment_id="ocid1.compartment.oc1..."
)
```

## Model Fine-Tuning

### Creating Fine-Tuned Models
```bash
# Create fine-tuning job
oci generative-ai model create \
  --compartment-id <compartment-ocid> \
  --base-model-id <foundation-model-ocid> \
  --training-dataset '{
    "datasetType": "OBJECT_STORAGE",
    "bucketName": "training-data",
    "namespaceName": "<namespace>",
    "objectName": "training.jsonl"
  }' \
  --fine-tune-details '{
    "trainingConfig": {
      "trainingConfigType": "TFEW_TRAINING_CONFIG",
      "totalTrainingEpochs": 3,
      "learningRate": 0.0001
    }
  }' \
  --display-name "CustomChatModel"

# List fine-tuned models
oci generative-ai model list \
  --compartment-id <compartment-ocid> \
  --lifecycle-state ACTIVE

# Get fine-tuning job status
oci generative-ai model get \
  --model-id <model-ocid>

# Delete fine-tuned model
oci generative-ai model delete \
  --model-id <model-ocid>
```

### Training Data Format (JSONL)
```json
{"prompt": "What is OCI Compute?", "completion": "OCI Compute provides scalable virtual machines and bare metal servers for running applications in the cloud."}
{"prompt": "Explain block storage", "completion": "Block storage in OCI provides persistent, high-performance storage volumes that can be attached to compute instances."}
{"prompt": "What is autonomous database?", "completion": "Autonomous Database is a fully managed, self-driving database service that automates provisioning, patching, backup, and tuning."}
```

## Best Practices

### Model Selection
1. **Task-appropriate models**: Use chat models for conversations, generation models for completion
2. **Embedding models**: Use for semantic search, document similarity, clustering
3. **Model size**: Larger models are more capable but more expensive
4. **Test with on-demand**: Prototype with on-demand before deploying dedicated endpoints

### Prompt Engineering
1. **Clear instructions**: Be specific about the task and desired output format
2. **System messages**: Use system role for consistent behavior across conversations
3. **Few-shot examples**: Include examples in prompt for better results
4. **Temperature tuning**: Lower (0.1-0.5) for factual, higher (0.7-1.0) for creative
5. **Max tokens**: Set appropriate limits to control cost and response length

### Performance Optimization
1. **Dedicated endpoints**: Use for production workloads with consistent traffic
2. **Caching**: Cache responses for identical prompts
3. **Batch processing**: Send multiple requests in parallel when possible
4. **Streaming**: Use for better user experience with long responses
5. **Token management**: Monitor and optimize token usage for cost control

### Security and Compliance
1. **Data privacy**: Don't send sensitive data to models without proper controls
2. **IAM policies**: Restrict model access using fine-grained policies
3. **Audit logging**: Enable and monitor GenAI service usage
4. **Custom models**: Fine-tune on your data kept within your tenancy
5. **Network security**: Use private endpoints for sensitive workloads

### Cost Management
1. **On-demand for development**: Use for testing and low-volume workloads
2. **Dedicated for production**: More cost-effective for high-volume usage
3. **Token optimization**: Reduce prompt size and max tokens where possible
4. **Model selection**: Choose smallest model that meets requirements
5. **Monitor usage**: Track tokens consumed and costs

## Common Use Cases

### Chatbot Implementation
```python
class OCIChatbot:
    def __init__(self, model_id, compartment_id):
        config = oci.config.from_file()
        self.client = GenerativeAiInferenceClient(config)
        self.model_id = model_id
        self.compartment_id = compartment_id
        self.conversation_history = []

    def chat(self, user_message):
        # Add user message to history
        self.conversation_history.append({
            "role": "user",
            "content": user_message
        })

        # Get AI response
        response = chat_with_ai(
            messages=self.conversation_history,
            model_id=self.model_id,
            compartment_id=self.compartment_id
        )

        # Add assistant response to history
        self.conversation_history.append({
            "role": "assistant",
            "content": response
        })

        return response

    def reset(self):
        self.conversation_history = []

# Usage
bot = OCIChatbot(model_id="ocid1...", compartment_id="ocid1...")
response1 = bot.chat("What is OCI?")
response2 = bot.chat("Tell me more about compute services")
```

### Document Q&A with Embeddings
```python
import numpy as np
from numpy.linalg import norm

class DocumentQA:
    def __init__(self, model_id, compartment_id):
        config = oci.config.from_file()
        self.client = GenerativeAiInferenceClient(config)
        self.model_id = model_id
        self.compartment_id = compartment_id
        self.documents = []
        self.embeddings = []

    def add_documents(self, documents):
        """Add documents and generate embeddings"""
        self.documents.extend(documents)
        new_embeddings = generate_embeddings(
            texts=documents,
            model_id=self.model_id,
            compartment_id=self.compartment_id
        )
        self.embeddings.extend(new_embeddings)

    def find_relevant(self, query, top_k=3):
        """Find most relevant documents for query"""
        # Generate query embedding
        query_embedding = generate_embeddings(
            texts=[query],
            model_id=self.model_id,
            compartment_id=self.compartment_id
        )[0]

        # Calculate cosine similarity
        similarities = []
        for doc_embedding in self.embeddings:
            similarity = np.dot(query_embedding, doc_embedding) / \
                        (norm(query_embedding) * norm(doc_embedding))
            similarities.append(similarity)

        # Get top-k documents
        top_indices = np.argsort(similarities)[-top_k:][::-1]
        relevant_docs = [self.documents[i] for i in top_indices]

        return relevant_docs

# Usage
qa = DocumentQA(model_id="ocid1...", compartment_id="ocid1...")
qa.add_documents([
    "OCI Compute provides virtual machines",
    "Block storage offers persistent volumes",
    "Autonomous Database is fully managed"
])
results = qa.find_relevant("Tell me about storage")
```

### Code Generation Assistant
```python
def generate_code(description, language="python"):
    """Generate code based on description"""
    prompt = f"""Generate {language} code for the following task:
{description}

Requirements:
- Include comments
- Follow best practices
- Handle errors appropriately

Code:"""

    response = generate_text(
        prompt=prompt,
        model_id="ocid1...",
        compartment_id="ocid1...",
        temperature=0.3  # Lower temperature for more deterministic code
    )

    return response

# Usage
code = generate_code(
    "Create a function to connect to Oracle Autonomous Database using Python",
    language="python"
)
print(code)
```

## IAM Policies for GenAI

### Allow Users to Use GenAI
```
Allow group AIUsers to use generative-ai-family in compartment AICompartment
Allow group AIUsers to read generative-ai-model in compartment AICompartment
```

### Allow Model Management
```
Allow group AIAdmins to manage generative-ai-family in compartment AICompartment
Allow group AIAdmins to manage generative-ai-model in compartment AICompartment
Allow group AIAdmins to manage generative-ai-endpoint in compartment AICompartment
```

### Allow Fine-Tuning
```
Allow group DataScientists to manage generative-ai-model in compartment AICompartment
Allow group DataScientists to read objectstorage-namespaces in tenancy
Allow service generativeai to read objects in compartment AICompartment where target.bucket.name='training-data'
```

## Building Agents with OCI OpenAI Package

### OCI OpenAI Package Overview

The **`oci-openai`** package is a Python library that enables developers to invoke OCI Generative AI models using familiar OpenAI SDK interfaces. Key benefits:

- **Seamless migration** from OpenAI to OCI GenAI
- **Automatic OCI authentication** handling
- **OpenAI API compatibility** for existing code
- **Multiple authentication methods** (user principal, instance principal, resource principal)

**Installation:**
```bash
pip install oci-openai
```

**GitHub:** https://github.com/oracle-samples/oci-openai

### Authentication Methods

```python
from oci_openai import OciUserPrincipalAuth
import httpx

# User Principal Auth (uses ~/.oci/config)
auth = OciUserPrincipalAuth(profile_name="DEFAULT")

# Instance Principal Auth (for compute instances)
from oci_openai import OciInstancePrincipalAuth
auth = OciInstancePrincipalAuth()

# Resource Principal Auth (for Functions)
from oci_openai import OciResourcePrincipalAuth
auth = OciResourcePrincipalAuth()
```

### Agent Building with OpenAI SDK

```python
import httpx
from openai import OpenAI
from oci_openai import OciUserPrincipalAuth
import json

COMPARTMENT_ID = "ocid1.compartment..."
model = "xai.grok-3-mini"  # or "cohere.command-r-plus"

client = OpenAI(
    api_key="OCI",
    base_url="https://inference.generativeai.us-chicago-1.oci.oraclecloud.com/20231130/actions/v1",
    http_client=httpx.Client(
        auth=OciUserPrincipalAuth(profile_name="DEFAULT"),
        headers={"CompartmentId": COMPARTMENT_ID}
    ),
)

# Define agent tools
def get_weather(city: str) -> str:
    """Get current temperature for a given city."""
    return f"The weather in {city} is sunny."

def get_stock_price(symbol: str) -> str:
    """Get stock price for a given symbol."""
    return f"The price of {symbol} is $150.25"

# Agent loop
def run_agent(model, instructions, tools, messages):
    """Run agent with tool calling"""
    # Convert functions to OpenAI tool schemas
    tool_schemas = [function_to_schema(tool) for tool in tools]
    tools_map = {tool.__name__: tool for tool in tools}

    while True:
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "system", "content": instructions}] + messages,
            tools=tool_schemas or None,
        )

        message = response.choices[0].message
        messages.append(message)

        if not message.tool_calls:
            return message.content

        # Execute tool calls
        for tool_call in message.tool_calls:
            name = tool_call.function.name
            args = json.loads(tool_call.function.arguments)
            result = tools_map[name](**args)

            messages.append({
                "role": "tool",
                "tool_call_id": tool_call.id,
                "content": result,
            })

# Use agent
messages = [{"role": "user", "content": "What's the weather in San Francisco?"}]
response = run_agent(
    model="xai.grok-3-mini",
    instructions="You are a helpful assistant.",
    tools=[get_weather, get_stock_price],
    messages=messages
)
```

### Agent Building with OpenAI Agents SDK

```python
import asyncio
from agents import Agent, Runner, AsyncOpenAI, function_tool, OpenAIChatCompletionsModel
import httpx
from oci_openai import OciUserPrincipalAuth

COMPARTMENT_ID = "ocid1.compartment..."

# Create OCI GenAI client
client = AsyncOpenAI(
    api_key="OCI",
    base_url="https://inference.generativeai.us-chicago-1.oci.oraclecloud.com/20231130/actions/v1",
    http_client=httpx.AsyncClient(
        auth=OciUserPrincipalAuth(profile_name="DEFAULT"),
        headers={"CompartmentId": COMPARTMENT_ID}
    )
)

model = OpenAIChatCompletionsModel(model="xai.grok-3-mini", openai_client=client)

@function_tool
def get_weather(city: str) -> str:
    """Get current temperature for a given city."""
    return f"The weather in {city} is sunny."

weather_agent = Agent(
    name="Weather Assistant",
    instructions="You are a helpful weather assistant.",
    tools=[get_weather],
    model=model
)

async def main():
    result = await Runner.run(weather_agent, input="What's the weather in Bangalore?")
    print(result.final_output)

if __name__ == "__main__":
    asyncio.run(main())
```

### Agent Building with LangChain

```python
from langchain.agents import create_agent
from langchain_openai import ChatOpenAI
import httpx
from oci_openai import OciUserPrincipalAuth

COMPARTMENT_ID = "ocid1.compartment..."

llm = ChatOpenAI(
    model="xai.grok-3-mini",
    api_key="OCI",
    base_url="https://inference.generativeai.us-chicago-1.oci.oraclecloud.com/20231130/actions/v1",
    http_client=httpx.Client(
        auth=OciUserPrincipalAuth(profile_name="DEFAULT"),
        headers={"CompartmentId": COMPARTMENT_ID}
    )
)

def get_weather(city: str) -> str:
    """Get current temperature for a given city."""
    return f"The weather in {city} is sunny."

weather_agent = create_agent(
    model=llm,
    tools=[get_weather],
    system_prompt="You are a helpful weather assistant.",
)

response = weather_agent.invoke(
    {"messages": {"role": "user", "content": "What is the weather like in Bangalore today?"}}
)
print(response["messages"][-1].content)
```

### Agent Building with LangGraph

```python
from langgraph.prebuilt import ToolNode, tools_condition
from langchain_core.tools import tool
from langgraph.graph import MessagesState, StateGraph, START, END
from langchain.messages import SystemMessage, HumanMessage
from langchain_openai import ChatOpenAI
import httpx
from oci_openai import OciUserPrincipalAuth

COMPARTMENT_ID = "ocid1.compartment..."

@tool
def get_weather(location: str) -> str:
    """Get current temperature for a given city."""
    return f"The weather in {location} is sunny."

llm_with_tools = ChatOpenAI(
    model="xai.grok-3-mini",
    api_key="OCI",
    base_url="https://inference.generativeai.us-chicago-1.oci.oraclecloud.com/20231130/actions/v1",
    http_client=httpx.Client(
        auth=OciUserPrincipalAuth(profile_name="DEFAULT"),
        headers={"CompartmentId": COMPARTMENT_ID}
    )
).bind_tools([get_weather])

def call_model(state: MessagesState):
    system_prompt = [SystemMessage(content="You are a helpful weather assistant.")]
    messages = state["messages"]
    response = llm_with_tools.invoke(system_prompt + messages)
    return {"messages": [response]}

# Build graph
agent_builder = StateGraph(MessagesState)
agent_builder.add_node("llm", call_model)
agent_builder.add_node("tools", ToolNode([get_weather]))
agent_builder.add_edge(START, "llm")
agent_builder.add_conditional_edges("llm", tools_condition, ["tools", END])
agent_builder.add_edge("tools", "llm")

weather_agent = agent_builder.compile()

response = weather_agent.invoke(
    input={"messages": [HumanMessage("What is the weather in Bangalore")]},
)
print(response["messages"][-1].content)
```

### Agent Building with Microsoft Agent Framework

```python
import asyncio
from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient
import httpx
from oci_openai import OciUserPrincipalAuth
from openai import AsyncOpenAI

def get_weather(city: str) -> str:
    """Get current temperature for a given city."""
    return f"The weather in {city} is sunny."

async def main() -> None:
    COMPARTMENT_ID = "ocid1.compartment..."

    oci_client = AsyncOpenAI(
        api_key="OCI",
        base_url="https://inference.generativeai.us-chicago-1.oci.oraclecloud.com/20231130/actions/v1",
        http_client=httpx.AsyncClient(
            auth=OciUserPrincipalAuth(profile_name="DEFAULT"),
            headers={"CompartmentId": COMPARTMENT_ID}
        )
    )

    chat_client = OpenAIChatClient(
        async_client=oci_client,
        model_id="xai.grok-3-mini"
    )

    weather_agent = ChatAgent(
        name="WeatherAgent",
        chat_client=chat_client,
        instructions="You are a helpful weather assistant.",
        tools=[get_weather]
    )

    query = "What's the weather like in Bangalore?"
    result = await weather_agent.run(query)
    print(f"Agent: {result}")

if __name__ == "__main__":
    asyncio.run(main())
```

### Available Models

Models available via OCI OpenAI package:

**Grok Models:**
- `xai.grok-3-mini` - Fast, cost-effective
- `xai.grok-4-fast-reasoning` - Advanced reasoning

**Cohere Models:**
- `cohere.command-r-plus` - Powerful command model
- `cohere.command-r` - Standard command model
- `cohere.command` - Base command model

**Meta Models:**
- `meta.llama-3.1-405b-instruct` - Largest Llama model
- `meta.llama-3.1-70b-instruct` - Balanced performance
- `meta.llama-3.1-8b-instruct` - Fast, efficient

### Agent Architecture Best Practices

**Tool Design:**
- Keep tools focused on single responsibility
- Provide clear docstrings (used for tool descriptions)
- Use type hints for parameters
- Return structured data when appropriate

**System Prompts:**
- Be specific about agent's role and capabilities
- Include constraints and limitations
- Provide examples of desired behavior
- Specify output format if needed

**Error Handling:**
```python
def safe_tool_call(func):
    """Decorator for safe tool execution"""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            return f"Error executing {func.__name__}: {str(e)}"
    return wrapper

@safe_tool_call
def get_database_info(query: str) -> str:
    """Execute database query safely"""
    # Database logic here
    pass
```

**Agent Testing:**
```python
# Test individual tools
assert get_weather("London") == "The weather in London is sunny."

# Test agent responses
messages = [{"role": "user", "content": "What's the weather in Tokyo?"}]
response = run_agent(agent, messages)
assert "Tokyo" in response
```

### Multi-Agent Orchestration

```python
# Create specialized agents
weather_agent = Agent(
    name="Weather Agent",
    instructions="Provide weather information.",
    tools=[get_weather],
    model=model
)

stock_agent = Agent(
    name="Stock Agent",
    instructions="Provide stock market information.",
    tools=[get_stock_price],
    model=model
)

# Router agent
async def route_query(query: str):
    """Route query to appropriate agent"""
    if "weather" in query.lower():
        return await Runner.run(weather_agent, input=query)
    elif "stock" in query.lower():
        return await Runner.run(stock_agent, input=query)
    else:
        return "I can help with weather or stock information."

# Usage
result = await route_query("What's the weather in NYC?")
```

### Resources

- **OCI OpenAI Package**: https://github.com/oracle-samples/oci-openai
- **OCI GenAI Documentation**: https://docs.oracle.com/en-us/iaas/Content/generative-ai/oci-openai.htm
- **A-Team Chronicles**: https://www.ateam-oracle.com/ (technical deep-dives)

## When to Use This Skill

Activate this skill when the user mentions:
- Generative AI, GenAI, or LLM services in OCI
- Text generation, completion, or chat with AI models
- Foundation models (Cohere, Llama, Grok, etc.)
- Embeddings for semantic search or similarity
- Fine-tuning models on custom data
- AI-powered chatbots or assistants
- Building agents with tools and function calling
- Multi-agent orchestration
- OCI OpenAI package or oci-openai
- LangChain, LangGraph, OpenAI Agents SDK integration
- Code generation with AI
- Document Q&A or RAG (Retrieval Augmented Generation)
- Prompt engineering or AI model parameters
- Dedicated AI clusters or inference endpoints

## Example Interactions

**User**: "How do I generate text with OCI GenAI?"
**Response**: Use this skill to show CLI and SDK examples for text generation with appropriate parameters.

**User**: "Create a chatbot using OCI"
**Response**: Use this skill to provide complete chatbot implementation with conversation history management.

**User**: "I need to do semantic search on my documents"
**Response**: Use this skill to demonstrate embeddings generation and similarity search implementation.

**User**: "How do I fine-tune a model with my data?"
**Response**: Use this skill to explain training data format and fine-tuning job creation.
