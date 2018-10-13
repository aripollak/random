#!/usr/bin/env node
/*
 * Sends push notification with the latest tweet using your OS's native library
 * To install dependencies:
 *   `npm -g install latest-tweets node-notifier`
 * Example usage to pop up latest tweet from @tinycarebot every hour:
 *   `NODE_PATH=/usr/local/lib/node_modules /path/to/twitter-notify.js tinycarebot 60`
 */

const latestTweets = require('latest-tweets');
const notifier = require('node-notifier');

const username = process.argv[2];
if(!username) throw 'expected Twitter username name as first argument';
const interval_min = process.argv[3]

const subtitle = '@' + username + ' (twitter-notify.js)';

function getLatestTweets() {
  latestTweets(username, (err, tweets) => {
    notifier.notify({title: tweets[0].content, message: subtitle, wait: false})
  });
}

setInterval(getLatestTweets, interval_min * 60 * 1000)
