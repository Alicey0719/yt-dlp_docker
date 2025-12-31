FROM python:3.14.2

ENV TZ=Asia/Tokyo

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN pip3 install --no-cache-dir --upgrade pip
RUN --mount=type=bind,target=. pip3 install --no-cache-dir -r requirements.txt
RUN rm -rf /tmp/*

RUN useradd yt-dlp
USER yt-dlp
WORKDIR /yt-dlp

ENTRYPOINT ["yt-dlp"]
CMD ["--help"]