from flask import Flask

app = Flask(__name__)


@app.get("/")
def root():
    return {"message": "Hello, World! CI/CD + K8s is alive 🚀"}


if __name__ == "__main__":
    # For local dev only
    app.run(host="0.0.0.0", port=5000, debug=True)
