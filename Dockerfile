FROM python:3.7.1
WORKDIR /xing
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD find . \( -name '__pycache__' -or -name '*.pyc' \) -delete
CMD tail -f /dev/null

