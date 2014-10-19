#!/bin/bash
# sidekiq    Init script for Sidekiq
#
# Description: Starts and Stops Sidekiq message processor for Stratus application.
#
# User-specified exit parameters used in this script:
#
# Exit Code 5 - Incorrect User ID
# Exit Code 6 - Directory not found

#Variable Set
APP_DIR="/home/rikas/hosting/youtube2mp3"
APP_CONFIG="$APP_DIR/config/sidekiq.yml"
LOG_FILE="$APP_DIR/log/sidekiq.log"
LOCK_FILE="$APP_DIR/tmp/sidekiq-lock"
PID_FILE="$APP_DIR/tmp/pids/sidekiq.pid"
GEMFILE="$APP_DIR/Gemfile"
APP_ENV="production"

START_CMD="bundle exec sidekiq -d -e $APP_ENV -P $PID_FILE -C $APP_CONFIG -L $LOG_FILE"
STOP_CMD="bundle exec sidekiqctl stop $PID_FILE"
QUIET_CMD="bundle exec sidekiqctl quiet $PID_FILE"
RETVAL=0

start() {
  status
  if [ $? -eq 1 ]; then
    [ `id -u` == '0' ] || (echo "sidekiq runs as root only..."; exit 5)
    [ -d $APP_DIR ] || (echo "$APP_DIR not found. Exiting..."; exit 6)
    cd $APP_DIR
    echo "Starting sidekiq message processor..."
    $START_CMD
    echo "Waiting for $PID_FILE to be present:"
    while [ ! -f $PID_FILE ]
    do
      sleep 1
      printf "."
    done
    printf "\n"

    RETVAL=$?
    [ $RETVAL -eq 0 ] && touch $LOCK_FILE
    return $RETVAL
  else
    echo "sidekiq message processor is already running..."
  fi
}

stop() {

  status
  if [ $? -eq 0 ]; then
    echo "Stopping sidekiq message processor..."
    cd $APP_DIR
    $STOP_CMD
    RETVAL=$?
    [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
    return $RETVAL
  else
    echo "sidekiq message processor is not running..."
  fi
}


status() {

  ps -ef | egrep 'sidekiq [0-9]+.[0-9]+.[0-9]+' | grep -v grep
  return $?
}

quiet() {

  status
  if [ $? -eq 0 ]; then
    echo "Asking sidekiq to stop accepting new work..."
    cd $APP_DIR
    $QUIET_CMD
    RETVAL=$?
    return $RETVAL
  else
    echo "sidekiq message processor is not running..."
  fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    quiet)
        quiet
        ;;
    status)
        status

        if [ $? -eq 0 ]; then
             echo "sidekiq message processor is running..."
             RETVAL=0
         else
             echo "sidekiq message processor is stopped..."
             RETVAL=1
         fi
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart|quiet}"
        exit 0
        ;;
esac
exit $RETVAL
