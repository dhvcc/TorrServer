#!/bin/sh

FLAGS="--path $TS_CONF_PATH --logpath $TS_LOG_PATH --port $TS_PORT --torrentsdir $TS_TORR_DIR"
if [[ "$TS_HTTPAUTH" -eq 1 ]]; then FLAGS="${FLAGS} --httpauth"; fi
if [[ "$TS_DOWNLOAD_DIR" ]]; then FLAGS="${FLAGS} --downloaddir $TS_DOWNLOAD_DIR"; fi
if [[ "$TS_RDB" -eq 1 ]]; then FLAGS="${FLAGS} --rdb"; fi
if [[ "$TS_DONTKILL" -eq 1 ]]; then FLAGS="${FLAGS} --dontkill"; fi
if [[ "$TS_EN_SSL" -eq 1 ]]; then FLAGS="${FLAGS} --ssl"; fi
if [[ -v "$TS_SSL_PORT" ]]; then FLAGS="${FLAGS} --sslport ${TS_SSL_PORT}"; fi


if [ ! -d $TS_CONF_PATH ]; then
  mkdir -p $TS_CONF_PATH
fi

if [ ! -d $TS_TORR_DIR ]; then
  mkdir -p $TS_TORR_DIR
fi

if [ ! -d $TS_DOWNLOAD_DIR ]; then
  mkdir -p $TS_DOWNLOAD_DIR
fi

if [ ! -f $TS_LOG_PATH ]; then
  touch $TS_LOG_PATH
fi

echo "Running with: ${FLAGS}"

# PATCH START Generate random credentials if none exist
if [ ! -f "$TS_CONF_PATH/accs.db" ]; then
  # Generate random credentials
  USERNAME="admin"
  # Generate random 16 character password using /dev/urandom
  PASSWORD=$(head -c 12 /dev/urandom | base64 | head -c 16)

  # Create torrserver credentials file
  cat > $TS_CONF_PATH/accs.db << EOF
  {
      "${USERNAME}": "${PASSWORD}"
  }
EOF
  echo "******** Information ********"
  echo "TorrServer credetials were auto generated"
  echo "TorrServer administrator username is: ${USERNAME}"
  echo "TorrServer administrator password is: ${PASSWORD}"
  echo "The credentials have been saved to ${TS_CONF_PATH}/accs.db"
fi
# PATCH END

torrserver $FLAGS
