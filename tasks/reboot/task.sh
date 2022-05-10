#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartTest
        if [[ "$TMT_REBOOT_COUNT" == "0" ]]; then
            rlRun "tmt-reboot"
        else
            rlLog "Successfully rebooted"
        fi
    rlPhaseEnd
rlJournalEnd
