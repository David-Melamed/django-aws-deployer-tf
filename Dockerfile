# Use an official Python runtime as a parent image
FROM python:3.9

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    jq \
    build-essential \
    libpq-dev \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /code

# Copy django project files
COPY django-app/*/ .

# List the contents of /code to verify
RUN ls -la /code

# Clone the repository
RUN pip install --upgrade pip && pip install -r requirements.txt

# Expose port 9090 for the Django app
EXPOSE 9090

RUN export DJANGO_PROJECT_NAME=$(find . -type f -name "settings.py" | sed 's|/settings.py||' | xargs -n 1 basename) && \
    echo "Detected Django project name: ${DJANGO_PROJECT_NAME}" && \
    echo "export DJANGO_PROJECT_NAME=${DJANGO_PROJECT_NAME}"
    
# Set environment variable for Django settings module
ENV DJANGO_SETTINGS_MODULE=${DJANGO_PROJECT_NAME}.settings

# Start the web_start.sh script
ENTRYPOINT ["/bin/bash", "/code/entrypoint.sh"]