#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartSetup
        rlRun "tmp=\$(mktemp -d)" 0 "Create tmp directory"
        rlRun "pushd $tmp"
        rlRun "set -o pipefail"
    rlPhaseEnd

    rlPhaseStartTest "Update"
        if [[ "$TMT_REBOOT_COUNT" == "0" ]]; then
            rlRun "rpm -qa | sort | tee old" 0 "Check packages before update"
            rlFileSubmit old
            rlRun "dnf --refresh update -y" 0 "Update to the latest packages"
            rlRun "dnf upgrade -y" 0 "Update to the latest packages"
            rlRun "dnf install dnf-plugin-system-upgrade -y" 0 "Install dnf upgrade plugin"
            if dnf repolist | grep testing-farm-tag-repository; then
                rlRun "dnf config-manager --disable testing-farm-tag-repository"
            fi
            rlRun "dnf system-upgrade download --releasever=$TARGET -y" 0 "Download new Fedora packages"
            if [ "$TARGET" -ge 42 ]; then
                rlRun "tmt-reboot -c \"dnf5 -y offline reboot\" -t 1800" 0 "Start actual upgrade"
            else
                rlRun "tmt-reboot -c \"dnf system-upgrade reboot\" -t 1800" 0 "Start actual upgrade"
            fi
        else
            rlLog "Successfully rebooted"
            rlRun "rpm -qa | sort | tee new" 0 "Check packages after update"
            rlRun "diff $TMT_TEST_DATA/old new" 1 "Compare package lists"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $tmp" 0 "Remove tmp directory"
    rlPhaseEnd
rlJournalEnd
