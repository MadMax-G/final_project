# Use an official Python runtime as a parent image
FROM python:3.7-slim-amd64

# Set the working directory in the container to /app
WORKDIR /app

ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r "requirements.txt"

# Make port 80 available to the world outside this container
EXPOSE 7070

# Run main.py when the container launches
CMD ["python", "database.py"]
