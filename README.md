## Using

Requires [Docker compose](https://github.com/docker/compose).

Run the container on docker-compose.yml

```sh
$ docker-compose up -d
```

Now the container is runing and ready to go.

### The Mysql
```sh
$ docker inspect project-sql
```
This will print a huge array, find the **IPAddress** key that will be your server host, the dbname, dbuser and db pass is set on docker-compose.yml, see [Mariadb](https://hub.docker.com/_/mariadb/)

if you neeed to importa a database dump into the docker use:
```sh
docker exec -i db mysql -uroot -plocal project < dump.sql
```

### The Project files
This is structure use unison to sync files from your machine to docker using a volume container.

```sh
$ docker inspect project-sql
```
This will print a huge array again, find the **IPAddress** key and replace on the command bellow.

```sh
unison webroot 'socket://172.22.0.2:5000/' -ignore 'Path .git' -auto -batch
```
This will be getting the files from de webroot folder and sync on apache webroot in the container. The problema here is, every change need to run this command to sync the files. Unison have a watch method but until this moment i can make work on my desktop.