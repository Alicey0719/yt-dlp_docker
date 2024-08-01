# yt-dlp_docker
## ex
- compose.yaml
```
services:
  yt-dlp:
    container_name: yt-dlp
    image: alicey/yt-dlp:latest
    volumes: 
      - ./yt-dlp:/yt-dlp # dl-dir
    command: ['https://www.youtube.com/watch?v=hogehogehiyohiyo']
```

- k8s manifests
```
{{- range .Values.ytdlSchedule }}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ .name }}
spec:
  schedule: "{{ .schedule }}"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: yt-dlp
              image: alicey/yt-dlp:latest
              command: ['bash', '-c', 'yt-dlp -o "/yt-dlp/%(title)s.%(ext)s" {{ .content }} || exit 0']
              volumeMounts:
                - mountPath: /yt-dlp
                  name: yt-dlp-storage
          restartPolicy: OnFailure
          volumes:
            - name: yt-dlp-storage
              persistentVolumeClaim:
                claimName: yt-dlp-pvc
{{- end }}
```
