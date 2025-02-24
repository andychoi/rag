# Dockerfile for Python App
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy app files
COPY . .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir streamlit psycopg2-binary python-dotenv

# Expose Streamlit port
EXPOSE 8501

# Default command to run Streamlit app
ENTRYPOINT ["streamlit", "run", "rag.py", "--server.enableCORS", "false", "--server.port=8501", "--server.address=0.0.0.0", "--server.enableXsrfProtection", "false"]