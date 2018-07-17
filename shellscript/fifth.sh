#!/bin/bash
crontab -e # enter the cron job file
00 14 * * 1-5  /home/rohan/Desktop/cr.sh #weekdays at 2 pm
00 8-20/3 * * * /home/rohan/Desktop/cr.sh #8am to 8pm at 3 hour interval
00 00 1-31/2 2-12/2 * /home/rohan/Desktop/cr.sh #odd dates at even hour interval

