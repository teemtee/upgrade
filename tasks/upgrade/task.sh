#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartSetup
        rlRun "tmp=\$(mktemp -d)" 0 "Create tmp directory"
        rlRun "pushd $tmp"
        rlRun "set -o pipefail"
    rlPhaseEnd

    rlPhaseStartTest "Update"
        rlRun "rpm -qa | sort | tee old" 0 "Check packages before update"
        rlRun "dnf --refresh update -y" 0 "Update to the latest packages"
        rlRun "dnf upgrade -y" 0 "Update to the latest packages"
        rlRun "dnf install dnf-plugin-system-upgrade -y" 0 "Install dnf upgrade plugin"
        rlRun "dnf system-upgrade download --releasever=$TARGET -y" 0 "Download new Fedora packages"
        rlRun "dnf system-upgrade reboot" 0 "start actual upgrade"
        rlRun "rpm -qa | sort | tee new" 0 "Check packages after update"
        rlRun "diff old new" 1 "Compare package lists"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $tmp" 0 "Remove tmp directory"
    rlPhaseEnd
rlJournalEnd
