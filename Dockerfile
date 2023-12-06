FROM docker.elastic.co/beats/filebeat:8.11.1

USER root

COPY --chown=root:filebeat configs/filebeat.yml /usr/share/filebeat/filebeat.yml
RUN chmod go-w /usr/share/filebeat/filebeat.yml

USER filebeat
RUN ls -la /usr/share/filebeat/filebeat.yml
