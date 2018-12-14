###############################################################################
## OCSINVENTORY-NG
## Copyleft Gilles Dubois 2017
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################

package Apache::Ocsinventory::Plugins::Vmware::Map;

use strict;

use Apache::Ocsinventory::Map;

$DATA_MAP{VMWARE_DATACENTER} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      HOST_FOLDER => {},
      NETWORK_FOLDER => {},
      VM_FOLDER => {},
      NAME => {},
      DATASTORE_FOLDER => {}
    }
  };

$DATA_MAP{VMWARE_DATASTORE} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      DATACENTER => {},
      IS_ACCESSIBLE => {},
      NAME => {},
      DATASTORE => {},
      MULTIPLE_HOST_ACCESS => {},
      CAPACITY => {},
      FREE_SPACE => {},
      THIN_PROVISIONING_SUPPORTED => {},
      TYPE => {}
    }
  };

$DATA_MAP{VMWARE_NETWORK} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      DATACENTER => {},
      NETWORK => {},
      NAME => {},
      TYPE => {}
    }
  };

$DATA_MAP{VMWARE_FOLDER} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      DATACENTER => {},
      FOLDER => {},
      NAME => {},
      TYPE => {}
    }
  };

$DATA_MAP{VMWARE_CLUSTER} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      DATACENTER => {},
      DRS_ENABLED => {},
      HA_ENABLED => {},
      NAME => {},
      CLUSTER => {},
    }
  };

$DATA_MAP{VMWARE_RESOURCEPOOL} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      DATACENTER => {},
      CLUSTER => {},
      HOST => {},
      RESOURCE_POOL => {},
      NAME => {}
    }
  };

$DATA_MAP{VMWARE_VM} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'VM',
    writeDiff => 0,
    cache => 0,
    fields => {
      DATACENTER => {},
      CLUSTER => {},
      HOST => {},
      RESOURCE_POOL => {},
      VM => {},
      CPU_COUNT => {},
      POWER_STATE => {},
      NAME => {},
      MEMORY_SIZE_MIB => {},
      GUEST_OS => {}
    }
  };

$DATA_MAP{VMWARE_VM_BOOT} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'VM',
    writeDiff => 0,
    cache => 0,
    fields => {
      VM => {},
      ENTER_SETUP_MODE => {},
      RETRY => {},
      EFI_LEGACY_BOOT => {},
      NETWORK_PROTOCOL => {},
      DELAY => {},
      RETRY_DELAY => {},
      TYPE => {}
    }
  };

$DATA_MAP{VMWARE_VM_HARDWARE} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'VM',
    writeDiff => 0,
    cache => 0,
    fields => {
      VM => {},
      VERSION => {},
      UPGRADE_STATUS => {},
      UPGRADE_VERSION => {},
      UPGRADE_POLICY => {}
    }
  };

$DATA_MAP{VMWARE_VM_CPU} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'VM',
    writeDiff => 0,
    cache => 0,
    fields => {
      VM => {},
      COUNT => {},
      HOT_ADD_ENABLED => {},
      HOT_REMOVE_ENABLED => {},
      CORES_PER_SOCKET => {}
    }
  };

$DATA_MAP{VMWARE_VM_MEMORY} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'VM',
    writeDiff => 0,
    cache => 0,
    fields => {
      VM => {},
      HOT_ADD_INCREMENT_SIZE => {},
      HOT_ADD_ENABLED => {},
      HOT_ADD_LIMIT_MIB => {},
      SIZE_MIB => {}
    }
  };

$DATA_MAP{VMWARE_VM_NETINTERFACE} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'VM',
    writeDiff => 0,
    cache => 0,
    fields => {
      VM => {},
      KEY_REF => {},
      WAKE_ON_LAN_ENABLED => {},
      START_CONNECTED => {},
      STATE => {},
      MAC_TYPE => {},
      MAC_ADDRESS => {},
      UPT_COMPATIBILITY_ENABLED => {},
      PCI_SLOT_NUMBER => {},
      LABEL => {},
      TYPE => {},
      BACKING_DISTRIBUTED_SWITCH_UUID => {},
      BACKING_DISTRIBUTED_PORT => {},
      BACKING_NETWORK => {}
    }
  };

$DATA_MAP{VMWARE_VM_DISK} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'VM',
    writeDiff => 0,
    cache => 0,
    fields => {
      VM => {},
      KEY_REF => {},
      BACKING_TYPE => {},
      BACKING_VMDK_FILE => {},
      LABEL => {},
      TYPE => {},
      CAPACITY => {},
      SCSI_UNIT => {},
      SCSI_BUS => {}
    }
  };

1;
