const express = require('express');
const WebSocket = require('ws');

const app = express();
const port = 3001
const wss = new WebSocket.Server({
    port: 8080
});

const request = require('request');
const MongoClient = require('mongodb').MongoClient;
const assert = require('assert');

// Connection URL
const url = "mongodb+srv://SenneS_Admin:SenneS2018@sennescluster-onimy.mongodb.net/SenneSDB";

// Database name
const dbName = "SenneSDB";

// Create a global variable for database access
var dbClient;

// We will also provide a websocket for better communication
wss.on('connection', function connection(ws) {
    ws.on('message', function incoming(message) {
        messageHandling(message, {
            send: obj => ws.send(JSON.stringify(obj))
        });
    });

    ws.send('something');
});

// Default route for webserver
app.get('/api', function (req, res) {
    // Try to parse the request object
    messageHandling(req.query['request'], res);
});

function messageHandling(requestObjectString, res) {
    let req_obj;
    try {
        req_obj = JSON.parse(requestObjectString);
    } catch (e) {
        // Catch errors
        res.send({
            error: 1,
            error_msg: 'Request object not provided or not in JSON format.'
        });
        return;
    }
    // Determin method
    let method = req_obj.method;
    console.log(method);
    if (!(method in methods)) {
        res.send({
            error: 2,
            error_msg: 'No method specified or method not existing.'
        });
    } else {
        // Call method
        methods[method](req_obj, res);
    }
}

// Dictionary containing all methods
let methods = {

    'get_updates': (req, res) => {
        // Getting fridge id
        let fridge_id = req.fridge_id;
        if (fridge_id === undefined || isNaN(fridge_id)) {
            res.send({
                error: 3,
                error_msg: 'fridge_id not specified.'
            });
            return;
        }
        // Getting the state
        let state = req.state;
        if (isNaN(state) || state === undefined) {
            state = 0;
        }
        getUpdates(fridge_id, state, (result) => res.send(result));
    },

    'add_update': (req, res) => {
        // Getting fridge id
        let fridge_id = req.fridge_id;
        if (fridge_id === undefined || isNaN(fridge_id)) {
            res.send({
                error: 3,
                error_msg: 'fridge_id not specified.'
            });
            return;
        }
        // Gett update BLOB
        let update = req.update;
        if (update === undefined) {
            res.send({
                error: 4,
                error_msg: 'No update blob provided.'
            });
            return;
        }
        console.log(update);
        addUpdate(fridge_id, update, (state) => {
            res.send({
                new_state: state,
                error: null
            });
        });
    },

    'barcode_info': (req, res) => {
        // Getting barcodes
        let barcodes = req.barcodes;
        console.log(barcodes);
        if (barcodes === undefined || !Array.isArray(barcodes)) {
            res.send({
                error: 5,
                error_msg: 'The barcodes parameter is required and must be an array of barcodes.'
            });
            return;
        }
        // Build response
        let result = {
            info: [],
            error: null
        }
        for (let ind in barcodes) {
            getBarcodeInfo(barcodes[ind], (info) => {
                result.info.push({
                    barcode : barcodes[ind],
                    info : info
                });
                if (result.info.length == barcodes.length) {
                    res.send(result);
                }
            });
        }
    }
}

// Connect to the Database
MongoClient.connect(url, {
    useNewUrlParser: true
}, function (err, client) {
    assert.equal(null, err);
    console.log("Connected successfully to SenneSDB");

    // Update the dbClient varaiable and use it make connections
    dbClient = client.db(dbName);
});


// This function should return the response for the get_updates method.
function getUpdates(fridgeId, state, callback) {

    // create the collection object for retrieving documents
    const collection = dbClient.collection("Fridges");

    // items from the DB are stored in an array of dictionaries
    // Need to fix this function as it is returning all fridge IDs over the state
    collection.find({
        state: {
            $gt: state
        },
        fridge_id: fridgeId
    }).toArray(function (err, items) {
        if (err) throw err;

        var updates = items.map(i => i.encrpyted_update);

        // Getting highest state
        collection.find({
            fridge_id: fridgeId.toString()
        }).sort({
            state: -1
        }).limit(1).toArray(function (err, lastUpdate) {
            var result = {
                new_state: lastUpdate != undefined && lastUpdate.length > 0 ? lastUpdate[0].state : 0,
                updates: updates,
                error: null
            };

            console.log(result);
    
            if (callback != undefined)
                callback(result);
        });
    });
}

// This function saves the update to the database and should return the new state.
function addUpdate(fridgeId, update, callback) {

    // Create the collection object for inserting documents into Fridges database
    const collection = dbClient.collection("Fridges");

    // Query the database to find the current highest state for this fridge
    collection.find({
        fridge_id: fridgeId.toString()
    }).sort({
        state: -1
    }).limit(1).toArray(function (err, maxState) {
        if (err) throw err;

        if (maxState.length == 0) {
            var newState = 1;
        } else {
            var newState = maxState[0].state + 1;
        }

        // Create the document containing the ID, state and string
        let fridgeUpdate = {
            fridge_id: fridgeId.toString(),
            state: newState,
            encrpyted_update: update
        };

        // insert the document into the DB
        collection.insertOne(fridgeUpdate, function (err, res) {
            if (err) throw err;

            if (callback != undefined)
                callback(newState);
        });
    });
}

// This function should query the digit-eyes.com database for the given barcode
function getBarcodeInfo(barcode, callback) {

    // Query for UPCitemdb database
    // let query = "https://api.upcitemdb.com/prod/trial/lookup?upc=" + barcode;
    const collection = dbClient.collection("Barcodes");
    collection.find({
        code : barcode
    }).limit(1).toArray((err, items) => {
        if (items == undefined || items.length == 0) {
            queryOpenFoodFacts(barcode, callback);
        } else {
            callback(items[0]);
        }
    });
}

function queryOpenFoodFacts(barcode, callback) {
    // Query Open Food Facts database
    let query = `https://world.openfoodfacts.org/api/v0/product/${barcode}.json`;

    console.log(query)

    const options = {
        url: query,
        method: 'GET',
        headers: {
            'Accept': 'application/json',
            'Accept-Charset': 'utf-8'
        }
    };

    // Parse the barcode information
    request(options, function (err, res, body) {
        if (err) throw err;
        console.log(body);
        let barcodeInfo = JSON.parse(body);
        console.log(barcodeInfo);
        // let item = barcodeInfo.items[0];
        let item = barcodeInfo.product;

        // Check if query has been successful
        if (barcodeInfo.status == 1) {
            const collection = dbClient.collection("Barcodes");
            // Store the returned JSON object in the Barcodes database
            collection.insertOne(item, function (err, res) {
                if (callback != undefined)
                    callback(item);
            });
        } else {
            callback({});
        }
    });
}

// Start server at port 3001
app.listen(port);
console.log(`Opened server at port ${port}!`)
