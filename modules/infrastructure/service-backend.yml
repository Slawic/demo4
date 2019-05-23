apiVersion: v1
kind: Service
metadata:
  name: eschool-api
spec:
  ports:
  - name: backend
    port: 8080
    protocol: TCP
  selector:
    name: eschool-backend
  type: LoadBalancer
  loadBalancerIP: ${lb_backend}
  