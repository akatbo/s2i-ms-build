# s2i-ms-build
FROM openshift/base-centos7

LABEL maintainer="Thabo Mpele <akatbo@gmail.com>"

ENV BUILDER_VERSION 1.0
ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.5.4

LABEL io.k8s.description="Platform for building and running Java8 applications" \
      io.k8s.display-name="Java8" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java8" \
      io.openshift.s2i.destination="/opt/app" \
      io.openshift.s2i.scripts-url=image:///usr/local/s2i

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/share/maven

RUN mkdir -p /opt/app

RUN adduser --system --base-dir /opt/app -u 10001 javauser && chown -R javauser: /opt/app

COPY ./s2i/bin /usr/local/s2i && chmod +x -R /usr/local/s2i

USER 10001

EXPOSE 8080

CMD ["/usr/local/s2i/usage"]