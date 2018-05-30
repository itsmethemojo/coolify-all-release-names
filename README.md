## run the application

### 1. git clone

```
git clone TODO
```

### 2. build container
```
docker build -t release-namer .
```

### 3. start local server
```
docker stop release-namer; \
docker rm release-namer; \
docker run -it -v$(pwd):/app --name release-namer -p3000:3000 release-namer bash -c 'cd /app; bundle install --path vendor/cache; bin/rails server -P /tmp/rails-pid'
```

### 4. open application
[link](http://localhost:3000)  
