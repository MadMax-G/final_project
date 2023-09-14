FROM alpine

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY app /app

# Install any needed packages specified in requirements.txt
#RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
#EXPOSE 9090

CMD ["chmod 777 /bin/sleep"]
# Run app.py when the container launches
#ENTRYPOINT ["python3", "database.py"]
CMD ["sleep", "3000"]
