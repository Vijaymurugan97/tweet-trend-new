FROM nginx:latest
ADD /jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrend.jar
ENTRYPOINT ["jar","-jar,","ttrend.jar" ]
