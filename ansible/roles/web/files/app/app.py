"""
Use Flask to print a message.
"""
from flask import Flask
import socket

app = Flask(__name__)


@app.route('/')
def hello_world() -> str:
    """
    Hello.
    :return: Message
    """
    return 'Hello world from ' + socket.gethostname() + '!'


if __name__ == '__main__':
    app.run(host='0.0.0.0')
