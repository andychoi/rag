# Stage 1: Builder
FROM python:3.12-slim AS builder

# Install build tools and required libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy only requirements to leverage Docker cache if unchanged.
COPY requirements.txt .

# Install Python dependencies including streamlit, psycopg2-binary, and python-dotenv.
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir streamlit psycopg2-binary python-dotenv

# Copy the rest of the application code.
COPY . .

# Stage 2: Runtime image
FROM python:3.12-slim

WORKDIR /workspace

# Copy installed packages and app files from the builder stage.
COPY --from=builder /usr/local /usr/local
COPY --from=builder /workspace /workspace

EXPOSE 8501

# Set the default command to run the Streamlit app.
ENTRYPOINT ["streamlit", "run", "rag.py", "--server.enableCORS", "false", "--server.port=8501", "--server.address=0.0.0.0", "--server.enableXsrfProtection", "false"]