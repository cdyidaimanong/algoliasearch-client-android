#! /bin/sh
GRADLE_FOLDER=~/.gradle/
GRADLE_PROPERTIES=$GRADLE_FOLDER/gradle.properties
KEY_PATH=`pwd`/tools/bitrise-secret.key

add_signing() {
    echo "Adding bitrise key to gradle properties..."
    cat > $GRADLE_PROPERTIES << EOF
signing.keyId=9719DC41
signing.password=
signing.secretKeyRingFile=$KEY_PATH
EOF
    echo "New gradle properties:"
    cat $GRADLE_PROPERTIES
}

if ! dpkg -l gnupg | grep -q gnupg; then
    echo "No gnupg* found. Installing gnupg2..."
    apt install gnupg2
fi

if [ ! -d $GRADLE_FOLDER ]
then
    mkdir $GRADLE_FOLDER
fi

if [ -e $GRADLE_PROPERTIES ]
then
    if grep -q "signing." $GRADLE_PROPERTIES
    then
        echo "The gradle properties already have a signing profile, leaving untouched."
        exit 0
    fi
else
    touch $GRADLE_PROPERTIES
fi

add_signing
gpg --import $KEY_PATH