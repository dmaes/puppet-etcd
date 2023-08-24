#
# @summary
#   This class manages a systemd timer to create snapshots
#
# @api private
#
class etcd::snapshot {
  assert_private()

  systemd::timer { 'etcd-snapshot.timer':
    ensure          => bool2str($etcd::snapshot, 'present', 'absent'),
    timer_content   => epp("${module_name}/snapshot.timer.epp", {
        oncalendar => $etcd::snapshot_oncalendar,
    }),
    service_content => epp("${module_name}/snapshot.service.epp", {
        env  => $etcd::etcdctl_env,
        path => $etcd::snapshot_path,
    }),
    enable          => $etcd::snapshot,
    active          => $etcd::snapshot,
  }
}
