#!/usr/bin/env node
/*
 * Sends push notification with the latest tweet using libnotify (GNOME, KDE)
 * To install dependencies:
 *   `npm -g install latest-tweets`
 * Example crontab usage to pop up latest tweet from @tinycarebot every hour during the work day:
 *   `0 9-17/1 * * 1-5 NODE_PATH=/usr/local/lib/node_modules /path/to/twitter-notify.js tinycarebot`
 */

let childProcess = require('child_process');
let latestTweets = require('latest-tweets');

let username = process.argv[2];
if(!username) throw 'expected Twitter username name as first argument';
let subtitle = '@' + username + ' (twitter-notify.js)';

latestTweets(username, (err, tweets) => {
  childProcess.execFile('notify-send', ['-i', 'emblem-favorite', tweets[0].content, subtitle]);
});
