docker_build() {
  echo 'docker_build: Enter'
  
  docker build --no-cache --build-arg JAVA_VERSION=$JAVA_VERSION -t $dockerRegistry/$dockerImageName:$JAVA_VERSION -t $dockerRegistry/$dockerImageName .

  echo 'Build container'
  
  #Check Build is successful
  if [ $? -eq 0 ]; then
      echo "Build Successful!"
  else
      echo "Build Failed!"
      exit 1
  fi
}

docker_build
