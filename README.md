# k8s Tutorial

# Tutorial 준비
- k8s 클러스터
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ git clone https://oss.navercorp.com/yoonje-c/k8s-tutorial.git
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ cd k8s-tutorial
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl version
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.0", GitCommit:"70132b0f130acc0bed193d9ba59dd186f0e634cf", GitTreeState:"clean", BuildDate:"2019-12-07T21:20:10Z", GoVersion:"go1.13.4", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.15", GitCommit:"2adc8d7091e89b6e3ca8d048140618ec89b39369", GitTreeState:"clean", BuildDate:"2020-09-02T11:31:21Z", GoVersion:"go1.13.15", Compiler:"gc", Platform:"linux/amd64"}
```

# Tutorial 1 - Pod와 기본 명령어 사용하기

#### Pod 생성하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl apply -f sample/pod.yaml
pod/nginx created
```

#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx                                1/1     Running   0          10s
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods -o wide
NAME                                 READY   STATUS    RESTARTS   AGE    IP              NODE            NOMINATED NODE   READINESS GATES
nginx                                1/1     Running   0          2m9s   10.161.35.143   xxxxxxxxxxxxx   <none>           <none>
```

#### Pod 상태 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl describe pod nginx
Name:         nginx
Namespace:    cyj
Priority:     0
Node:         xxxxxxxxxxxxx/xxxxxxxxxxxxx
Start Time:   Wed, 15 Mar 2023 15:27:20 +0900
Labels:       <none>
Status:       Running
IP:           xxxxxxxxxxxxx
IPs:
  IP:  xxxxxxxxxxxxx
Containers:
  nginx:
    Container ID:   docker://3cfac59b7c44c25dba8df7b16230dadbba7a8b68ccc1dd173dd68c740e1a169c
    Image:          nginx:1.14.2
    Image ID:       docker-pullable://nginx@sha256:f7988fb6c02e0ce69257d9bd9cf37ae20a60f1df7563c3a2a6abe24160306b8d
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 15 Mar 2023 15:27:28 +0900
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:                4
      ephemeral-storage:  8Gi
      memory:             4Gi
      ncc/type.any:       1
    Requests:
      cpu:                100m
      ephemeral-storage:  8Gi
      memory:             512Mi
      ncc/type.any:       1
    Environment:
      NCC_CLUSTER_NAME:     pgd1
      NCC_CLUSTER_NETWORK:  develop
      NCC_CLUSTER_PHASE:    develop
      TZ:                   Asia/Seoul
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-v7p9r (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-v7p9r:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-v7p9r
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                    Message
  ----    ------     ----  ----                    -------
  Normal  Scheduled  47s   default-scheduler       Successfully assigned cyj/nginx to xxxxxxxxxxxxx
  Normal  Pulling    46s   kubelet, xxxxxxxxxxxxx  Pulling image "nginx:1.14.2"
  Normal  Pulled     40s   kubelet, xxxxxxxxxxxxx  Successfully pulled image "nginx:1.14.2"
  Normal  Created    39s   kubelet, xxxxxxxxxxxxx  Created container nginx
  Normal  Started    39s   kubelet, xxxxxxxxxxxxx  Started container nginx
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ curl 10.161.35.143:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

#### Pod 속 컨테이너 로그 확인하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl logs -f nginx -c nginx
10.25.32.78 - - [15/Mar/2023:15:30:06 +0900] "GET / HTTP/1.1" 200 612 "-" "curl/7.79.1" "-"
```

#### Pod 속 컨테이너 접속하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl exec -it nginx -c nginx /bin/bash
root@nginx:/# ls
bin  boot  dev	etc  home  lib	lib64  media  mnt  opt	proc  root  run  sbin  srv  sys  tmp  usr  var
root@nginx:/# exit
```

#### Pod 삭제하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl delete pod nginx
pod "nginx" deleted
```

# Tutorial 2 - Deployment로 애플리케이션 배포하기

#### Deployment로 nginx 배포하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl apply -f sample/deployment.yaml
deployment.apps/nginx-deployment created
```

#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-deployment-b974549f7-28nkd     1/1     Running   0          13s
nginx-deployment-b974549f7-8kjh7     1/1     Running   0          13s
nginx-deployment-b974549f7-m828w     1/1     Running   0          13s
```

#### Deployment 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           108s
```

#### ReplicaSet 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get rs
NAME                         DESIRED   CURRENT   READY   AGE
nginx-deployment-b974549f7   3         3         3       2m7s
```

#### Deployment로 replicas 개수 바꿔서 nginx 배포하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ vi sample/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 5 # 5개로 수정
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl apply -f sample/deployment.yaml
deployment.apps/nginx-deployment configured
```

#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-deployment-b974549f7-28nkd     1/1     Running   0          4m24s
nginx-deployment-b974549f7-7wx7z     1/1     Running   0          20s
nginx-deployment-b974549f7-8kjh7     1/1     Running   0          4m24s
nginx-deployment-b974549f7-ckpl6     1/1     Running   0          20s
nginx-deployment-b974549f7-m828w     1/1     Running   0          4m24s
```

#### Deployment 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   5/5     5            5           4m43s
```

#### ReplicaSet 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get rs
NAME                         DESIRED   CURRENT   READY   AGE
nginx-deployment-b974549f7   5         5         5       4m47s
```

#### Deployment로 배포된 파드 삭제하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl delete pod nginx-deployment-b974549f7-28nkd
pod "nginx-deployment-b974549f7-28nkd" deleted
```

#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-deployment-b974549f7-7wx7z     1/1     Running   0          3m9s
nginx-deployment-b974549f7-8kjh7     1/1     Running   0          7m13s
nginx-deployment-b974549f7-ckpl6     1/1     Running   0          3m9s
nginx-deployment-b974549f7-m828w     1/1     Running   0          7m13s
nginx-deployment-b974549f7-wljwt     1/1     Running   0          4s
```

#### Deployment로 삭제하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl delete deployment nginx-deployment
deployment.extensions "nginx-deployment" deleted
```
#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
```

#### Deployment로 nginx 재배포하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl apply -f sample/deployment.yaml
deployment.apps/nginx-deployment created
```

# Tutorial 3 - Service로 애플리케이션 외부에 노출하기

#### Service 생성하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl apply -f sample/service.yaml
service/nginx-svc created
```

#### Service 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get svc
NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                      AGE
nginx-svc                          LoadBalancer   172.24.250.48    10.161.122.175   80:35617/TCP,443:40987/TCP   33s
```

#### Service EXTERNAL-IP로 외부에서 접근하기
<img width="1509" alt="스크린샷 2023-03-15 오후 3 51 10" src="https://user-images.githubusercontent.com/38535571/225233374-a9987ab1-e635-4d3f-8315-9ccb6ec84e6d.png">

# Tutorial 4 - HPA 사용하기 Part 1

#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-deployment-b974549f7-86nzt     1/1     Running   0          5m23s
nginx-deployment-b974549f7-dxj6z     1/1     Running   0          5m23s
nginx-deployment-b974549f7-j52ms     1/1     Running   0          5m23s
nginx-deployment-b974549f7-ltrgj     1/1     Running   0          5m23s
nginx-deployment-b974549f7-zd2xp     1/1     Running   0          5m23s
```

#### autoscale 명령 사용하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl autoscale deployment nginx-deployment --cpu-percent=50 --min=7 --max=15
horizontalpodautoscaler.autoscaling/nginx-deployment autoscaled
```

#### hpa 확인하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get hpa
NAME               REFERENCE                     TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
nginx-deployment   Deployment/nginx-deployment   <unknown>/50%   7         15        5          22s
```

#### deployment 확인하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   6/7     7            6           7m21s
```

#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-deployment-b974549f7-4bxgz     1/1     Running   0          85s
nginx-deployment-b974549f7-86nzt     1/1     Running   0          8m29s
nginx-deployment-b974549f7-9bcm4     1/1     Running   0          85s
nginx-deployment-b974549f7-dxj6z     1/1     Running   0          8m29s
nginx-deployment-b974549f7-j52ms     1/1     Running   0          8m29s
nginx-deployment-b974549f7-ltrgj     1/1     Running   0          8m29s
nginx-deployment-b974549f7-zd2xp     1/1     Running   0          8m29s
```

#### hpa 삭제하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl delete hpa nginx-deployment
horizontalpodautoscaler.autoscaling "nginx-deployment" deleted
```

# Tutorial 5 - HPA 사용하기 Part 2

#### HorizontalPodAutoscaler 사용하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-deployment-b974549f7-4bxgz     1/1     Running   0          6m16s
nginx-deployment-b974549f7-86nzt     1/1     Running   0          13m
nginx-deployment-b974549f7-9bcm4     1/1     Running   0          6m16s
nginx-deployment-b974549f7-dxj6z     1/1     Running   0          13m
nginx-deployment-b974549f7-j52ms     1/1     Running   0          13m
nginx-deployment-b974549f7-ltrgj     1/1     Running   0          13m
nginx-deployment-b974549f7-zd2xp     1/1     Running   0          13m
```

#### HorizontalPodAutoscaler 생성하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl apply -f sample/hpa.yaml
horizontalpodautoscaler.autoscaling/hpa-resource-cpu created
```

#### hpa 확인하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ kubectl get hpa
NAME               REFERENCE                     TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
hpa-resource-cpu   Deployment/nginx-deployment   <unknown>/50%   10        20        7          19s
```

#### deployment 확인하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~] $ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   10/10   10           10          16m
```

#### Pod 목록 조회하기
```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~] $ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-deployment-b974549f7-4bxgz     1/1     Running   0          9m33s
nginx-deployment-b974549f7-86nzt     1/1     Running   0          16m
nginx-deployment-b974549f7-8mf4m     1/1     Running   0          51s
nginx-deployment-b974549f7-9bcm4     1/1     Running   0          9m33s
nginx-deployment-b974549f7-9c77q     1/1     Running   0          51s
nginx-deployment-b974549f7-dxj6z     1/1     Running   0          16m
nginx-deployment-b974549f7-j52ms     1/1     Running   0          16m
nginx-deployment-b974549f7-ltrgj     1/1     Running   0          16m
nginx-deployment-b974549f7-qn8tj     1/1     Running   0          51s
nginx-deployment-b974549f7-zd2xp     1/1     Running   0          16m
```
