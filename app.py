from flask import Flask, request, jsonify
import redis
import itertools
app = Flask(__name__)


REDIS_PREFIX = "gitsampler:commits:"


@app.route('/data.json')
def api_get_redis():
    r = redis.StrictRedis(decode_responses=True)
    query = request.args.get('q', "")

    if query == "":
        query = REDIS_PREFIX + "*"
    else:
        query = REDIS_PREFIX + "*" + '*'.join(query.split(' ')) + "*"

    keys = itertools.islice(r.scan_iter(query), 100)
    results = list(r.hgetall(key) for key in keys)
    return jsonify(results=results)

if __name__ == '__main__':
    app.run(debug=True)
