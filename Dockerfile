FROM python:3.10

# Set the working directory to /app
WORKDIR /app

Run pip install flask pymongo
# Copy the current directory contents into the container at /app
COPY app /app

# Make port 80 available to the world outside this container
EXPOSE 9090

# Run app.py when the container launches
CMD ["python", "database.py"]
