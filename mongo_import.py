from pymongo import MongoClient
import json
import time

BATCHSIZE = 5000
client = MongoClient('mongodb+srv://admin:admin@cluster0.fqbgwci.mongodb.net/test')

db = client['zadanie6']


def import_conversations():
    collection = db['conversations']
    with open('conversations.json', 'r', encoding='utf8') as f:
        x = 0
        start = time.time()
        documents = []
        for line in f:
            x += 1
            documents.append(json.loads(line))

            if len(documents) == BATCHSIZE:
                collection.insert_many(documents)
                print(x)
                documents = []

        #send final data
        collection.insert_many(documents)
        print(x)
        print('Final time:')
        print(time.time() - start)
    return

def import_authors():
    collection = db['authors']
    with open('authors.json', 'r', encoding='utf8') as f:
        x = 0
        start = time.time()
        documents = []
        for line in f:
            x += 1
            documents.append(json.loads(line))

            if len(documents) == BATCHSIZE:
                collection.insert_many(documents)
                print(x)
                documents = []

        #send final data
        collection.insert_many(documents)
        print(x)
        print('Final time:')
        print(time.time() - start)
    return

import_conversations()
#import_authors()