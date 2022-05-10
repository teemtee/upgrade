#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartTest
        rlRun "uname -a" 0 "Check kernel before update"
        rlAssertGrep "VERSION_ID=$SOURCE" /etc/os-release
    rlPhaseEnd
rlJournalEnd
