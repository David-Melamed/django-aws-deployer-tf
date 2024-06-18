# Use an official Python runtime as a parent image
FROM python:3.9

ARG django_project_url
ARG django_project_path

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DJANGO_PROJECT_URL $django_project_url
ENV DJANGO_PROJECT_PATH $django_project_path


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

COPY django-app/SWAP-Web/SWAP/django_swap/requirements.txt /code/

# Clone the repository
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY django-app/SWAP-Web/SWAP/django_swap/  /code/

# Expose port 9090 for the Django app
EXPOSE 9090

# Define environment variables for Django settings
ENV DJANGO_SETTINGS_MODULE=django_main.settings

# Start the web_start.sh script
ENTRYPOINT ["/bin/bash", "/code/entrypoint.sh"]