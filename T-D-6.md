Project 01: Deploying a Node.js App Using Minikube Kubernetes
Overview

This project guides you through deploying a Node.js application using Minikube Kubernetes. You'll use Git for version control, explore branching and fast-forward merges, and set up Kubernetes services and deployment pods, including ClusterIP and NodePort service types.
Prerequisites

    Minikube installed
    kubectl installed
    Git installed
    Node.js installed (Download Node.js)

Project Steps
1. Initialize a Git Repository

    Create a new directory for your project:

    sh

mkdir nodejs-k8s-project
cd nodejs-k8s-project

Initialize a Git repository:

sh

    git init

2. Create a Node.js Application

    Initialize a Node.js project:

    sh

npm init -y

Install Express.js:

sh

npm install express

Create an index.js file with the following content:

javascript

const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello, Kubernetes!');
});

app.listen(port, () => {
    console.log(`App running at http://localhost:${port}`);
});

Create a .gitignore file to ignore node_modules:

sh

    echo "node_modules" > .gitignore

3. Commit the Initial Code

    Add files to Git:

    sh

git add .

Commit the changes:

sh

    git commit -m "Initial commit with Node.js app"

4. Branching and Fast-Forward Merge

    Create and switch to a new branch feature/add-route:

    sh

git checkout -b feature/add-route

Implement a new route in index.js:

javascript

app.get('/newroute', (req, res) => {
    res.send('This is a new route!');
});

Commit the changes:

sh

git add .
git commit -m "Add new route"

Switch back to the main branch:

sh

git checkout main

Merge the feature/add-route branch using fast-forward:

sh

git merge --ff-only feature/add-route

Delete the feature branch:

sh

    git branch -d feature/add-route

5. Containerize the Node.js Application

    Create a Dockerfile:

    Dockerfile

FROM node:14
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "index.js"]

Build the Docker image:

sh

docker build -t nodejs-k8s-app .

Run the Docker container to test:

sh

    docker run -p 3000:3000 nodejs-k8s-app

    Access http://localhost:3000/newroute to see the app running.

6. Deploying to Minikube Kubernetes

    Start Minikube:

    sh

minikube start

Create a deployment.yaml file:

yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-app
  template:
    metadata:
      labels:
        app: nodejs-app
    spec:
      containers:
      - name: nodejs-app
        image: nodejs-k8s-app:latest
        ports:
        - containerPort: 3000

Create a service.yaml file for ClusterIP:

yaml

apiVersion: v1
kind: Service
metadata:
  name: nodejs-service
spec:
  selector:
    app: nodejs-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: ClusterIP

Create a service-nodeport.yaml file for NodePort:

yaml

    apiVersion: v1
    kind: Service
    metadata:
      name: nodejs-service-nodeport
    spec:
      selector:
        app: nodejs-app
      ports:
      - protocol: TCP
        port: 80
        targetPort: 3000
        nodePort: 30001
      type: NodePort

7. Apply Manifests to Minikube

    Apply the deployment:

    sh

kubectl apply -f deployment.yaml

Apply the ClusterIP service:

sh

kubectl apply -f service.yaml

Apply the NodePort service:

sh

    kubectl apply -f service-nodeport.yaml

8. Access the Application

    Get the Minikube IP:

    sh

minikube ip

Access the application using the NodePort:

sh

    curl http://<Minikube_IP>:30001

9. Making Changes to the App and Redeploying Using Kubernetes

    Create and switch to a new branch feature/update-message:

    sh

git checkout -b feature/update-message

Update the application in index.js:

javascript

const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello, Kubernetes! Updated version.');
});

app.get('/newroute', (req, res) => {
    res.send('This is a new route!');
});

app.listen(port, () => {
    console.log(`App running at http://localhost:${port}`);
});

Commit the changes:

sh

git add .
git commit -m "Update main route message"

Switch back to the main branch:

sh

git checkout main

Merge the feature/update-message branch:

sh

git merge --ff-only feature/update-message

Delete the feature branch:

sh

git branch -d feature/update-message

Rebuild the Docker image with a new tag:

sh

    docker build -t nodejs-k8s-app:v2 .

10. Update Kubernetes Deployment

    Modify deployment.yaml to use the new image version:

    yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-app
  template:
    metadata:
      labels:
        app: nodejs-app
    spec:
      containers:
      - name: nodejs-app
        image: nodejs-k8s-app:v2
        ports:
        - containerPort: 3000

Apply the updated deployment:

sh

kubectl apply -f deployment.yaml

Verify the update:

sh

    kubectl rollout status deployment/nodejs-app

11. Access the Updated Application

    Forward the port to access the ClusterIP service:

    sh

kubectl port-forward service/nodejs-service 8080:80

Open your browser and navigate to http://localhost:8080 to see the updated message.

Access the application using the NodePort:

sh

    curl http://<Minikube_IP>:30001

Project 02: Deploying a Python Flask App Using Minikube Kubernetes
Overview

This project guides you through deploying a Python Flask application using Minikube Kubernetes. You'll use Git for version control, explore branching and fast-forward merges, and set up Kubernetes services and deployment pods, including ClusterIP and NodePort service types.
Prerequisites

    Minikube installed
    kubectl installed
    Git installed
    Python installed

Project Steps
1. Set Up Git Version Control

    Create a new directory for your project:

    sh

mkdir flask-k8s-project
cd flask-k8s-project

Initialize a Git repository:

sh

    git init

2. Create a Python Flask Application

    Create a virtual environment:

    sh

python -m venv venv
source venv/bin/activate

Install Flask:

sh

pip install Flask

Create an app.py file with the following content:

python

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Kubernetes!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

Create a requirements.txt file to list the dependencies:

Flask

Create a .gitignore file to ignore venv:

sh

    echo "venv" > .gitignore

3. Commit the Initial Code

    Add files to Git:

    sh

git add .

Commit the changes:

sh

    git commit -m "Initial commit with Flask app"

4. Branching and Fast-Forward Merge

    Create and switch to a new branch feature/add-route:

    sh

git checkout -b feature/add-route

Implement a new route in app.py:

python

@app.route('/newroute')
def new_route():
    return 'This is a new route!'

Commit the changes:

sh

git add .
git commit -m "Add new route"

Switch back to the main branch:

sh

git checkout main

Merge the feature/add-route branch using fast-forward:

sh

git merge --ff-only feature/add-route

Delete the feature branch:

sh

    git branch -d feature/add-route

5. Containerize the Flask Application

    Create a Dockerfile:

    Dockerfile

FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]

Build the Docker image:

sh

docker build -t flask-k8s-app .

Run the Docker container to test:

sh

    docker run -p 5000:5000 flask-k8s-app

    Access http://localhost:5000 to see the app running.

6. Deploying to Minikube Kubernetes

    Start Minikube:

    sh

minikube start

Create a deployment.yaml file:

yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: flask-k8s-app:latest
        ports:
        - containerPort: 5000

Create a service.yaml file for ClusterIP:

yaml

apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  selector:
    app: flask-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 5000
  type: ClusterIP

Create a service-nodeport.yaml file for NodePort:

yaml

    apiVersion: v1
    kind: Service
    metadata:
      name: flask-service-nodeport
    spec:
      selector:
        app: flask-app
      ports:
      - protocol: TCP
        port: 80
        targetPort: 5000
        nodePort: 30001
      type: NodePort

7. Apply Manifests to Minikube

    Apply the deployment:

    sh

kubectl apply -f deployment.yaml

Apply the ClusterIP service:

sh

kubectl apply -f service.yaml

Apply the NodePort service:

sh

    kubectl apply -f service-nodeport.yaml

8. Access the Application

    Get the Minikube IP:

    sh

minikube ip

Access the application using the NodePort:

sh

    curl http://<Minikube_IP>:30001

9. Clean Up

    Stop Minikube:

    sh

minikube stop

Delete Minikube cluster:

sh

    minikube delete

10. Making Changes to the Flask Application

    Create and switch to a new branch feature/update-message:

    sh

git checkout -b feature/update-message

Update the application in app.py:

python

@app.route('/')
def hello_world():
    return 'Hello, Kubernetes! Updated version.'

@app.route('/newroute')
def new_route():
    return 'This is a new route!'

Commit the changes:

sh

git add .
git commit -m "Update main route message"

Switch back to the main branch:

sh

git checkout main

Merge the feature/update-message branch:

sh

git merge --ff-only feature/update-message

Delete the feature branch:

sh

git branch -d feature/update-message

Rebuild the Docker image with a new tag:

sh

    docker build -t flask-k8s-app:v2 .

11. Update Kubernetes Deployment

    Modify deployment.yaml to use the new image version:

    yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: flask-k8s-app:v2
        ports:
        - containerPort: 5000

Apply the updated deployment:

sh

kubectl apply -f deployment.yaml

Verify the update:

sh

    kubectl rollout status deployment/flask-app

12. Access the Updated Application

    Forward the port to access the ClusterIP service:

    sh

kubectl port-forward service/flask-service 8080:80

Open your browser and navigate to http://localhost:8080 to see the updated message.

Access the application using the NodePort:

sh

curl http://<Minikube_IP>:30001