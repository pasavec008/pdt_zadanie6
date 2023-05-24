from pymongo import MongoClient
import json

client = MongoClient('mongodb+srv://admin:admin@cluster0.fqbgwci.mongodb.net/test')
db = client['zadanie6']
collection = db['conversations']

first_query = '''[
    {
        "$lookup": {
            "from": "authors",
            "localField": "author_id",
            "foreignField": "_id",
            "as": "author"
        }
    },
    {"$unwind": "$author"},
    {"$match": {"author.username": "Newnews_eu"}},
    {"$sort": {"created_at": -1}},
    {"$limit": 10}
]'''
# results1 = collection.aggregate(json.loads(first_query))
# for r in results1:
#     print(r)

second_query = '''[
    {"$unwind": "$conversation_references"},
    {"$match":{
        "$and":[
        {"conversation_references.parent_conversation_id": 1496830803736731649},
        {"conversation_references.type": "retweeted"}
        ]
    }},
    {"$sort": {"created_at": -1}},
    {"$limit": 10}
]'''
results2 = collection.aggregate(json.loads(second_query))
for r in results2:
    print(r)