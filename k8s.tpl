apiVersion: v1
kind: Service
metadata:
  name: <app>-service
  labels:
    app: <app>
spec:
  selector:
    app: <app>
  ports:
  - name: web
    protocol: TCP
    port: 80
    targetPort: <containerPort>

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: <app>-deployment
  labels:
    app: <app>
spec:
  replicas: 1
  selector:
    matchLabels:
      app: <app>
  template:
    metadata:
      labels:
        app: <app>
    spec:
      containers:
      - name: <app>
        image: <image>
        ports:
        - containerPort: <containerPort>
