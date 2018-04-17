#!/usr/bin/env node
/*
 * Sends push notification with the latest tweet using libnotify (GNOME, KDE)
 * To install dependencies:
 *   `npm -g install latest-tweets`
 * Example usage to pop up latest tweet from @tinycarebot every hour:
 *   `NODE_PATH=/usr/local/lib/node_modules /path/to/twitter-notify.js tinycarebot 60`
 */

const childProcess = require('child_process');
const latestTweets = require('latest-tweets');

const username = process.argv[2];
if(!username) throw 'expected Twitter username name as first argument';
const interval_min = process.argv[3]

const subtitle = '@' + username + ' (twitter-notify.js)';

function getLatestTweets() {
  latestTweets(username, (err, tweets) => {
    childProcess.execFile('notify-send', ['-i', 'emblem-favorite', tweets[0].content, subtitle]);
  });
}

setInterval(getLatestTweets, interval_min * 60 * 1000)
