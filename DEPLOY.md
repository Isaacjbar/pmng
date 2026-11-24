# Deploy automático (Jenkins)

Cada push a `main` despliega pmng solo, en la EC2 `jenkins-docker` (us-east-1):

1. GitHub manda un webhook *push* a `http://<IP-EC2>:8080/github-webhook/`.
2. Jenkins corre el job **pmng**:
   - Clona por SSH con una deploy key de solo lectura (credencial `github-deploy-key`).
   - Ejecuta el `Jenkinsfile`.
3. El `Jenkinsfile` sigue estos pasos:
   - Copia el `.env` desde la credencial `pmng-env`.
   - `docker compose down`.
   - Borra las imágenes viejas.
   - `docker compose build --no-cache`.
   - `docker compose up -d`.

| Servicio | Puerto |
|---|---|
| Front (`pmng-cliente`) | 5173 |
| Back (`pmng-servicios`) | 8089 |
| MySQL (`pmng-persistance`) | solo red interna |

> La IP pública cambia cada vez que se reinicia el lab de AWS Academy. Cuando cambie, hay que actualizar la URL del webhook y la de Jenkins.
