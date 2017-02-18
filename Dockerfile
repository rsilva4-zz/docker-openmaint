
FROM tomcat:8-jre8

EXPOSE 8080

RUN	apt-get update && \
	apt-get install -y postgresql-client netcat unzip gettext-base fontconfig

WORKDIR /tmp
ENV OPENMAINT_ZIP_URL=http://downloads.sourceforge.net/project/openmaint/1.1/openmaint-1.1-2.4.2.zip \
	PGSQL_JDBC_DRIVER_URL=https://jdbc.postgresql.org/download/postgresql-9.4.1208.jar

RUN set -x \
	&& curl -fSL "$OPENMAINT_ZIP_URL" -o openmaint.zip \	
	&& unzip openmaint.zip  \
	&& rm openmaint.zip \
	&& mv openmaint* openmaint
COPY configuration /tmp/openmaint/configuration
RUN set -x \
	&& curl -fSL "$PGSQL_JDBC_DRIVER_URL" -O \
	&& mv postgresql* $CATALINA_HOME/lib/

COPY docker-entrypoint.sh /
WORKDIR $CATALINA_HOME

## OPENMAINT CONFIGURATION {

ENV OPENMAINT_DEFAULT_LANG=en

ENV DB_USER=postgres \
	DB_PASS=test \	
	DB_HOST=postgres \
	DB_PORT=5432 \
	DB_NAME=cmdbuild

ENV BIM_ACTIVE=false \
	BIM_URL=http://bimserver:8080/bimserver \
	BIM_USER=admin@example.org \
	BIM_PASSWORD=bimserver

ENV GIS_ENABLED=false \
	GEOSERVER_ON_OFF=off \
	GEOSERVER_URL=http://geoserver:8080/geoserver \
	GEOSERVER_USER=admin \
	GEOSERVER_PASSWORD=geoserver \
	GEOSERVER_WORKSPACE=cmdbuild

## }

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["openmaint"]