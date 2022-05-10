#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartTest
        rlRun "uname -a" 0 "Check kernel after update"
        rlAssertGrep "VERSION_ID=$TARGET" /etc/os-release
    rlPhaseEnd
rlJournalEnd
