import requests


def test():
    response = requests.get("http://localhost:7070")
    assert response.status_code == 200

